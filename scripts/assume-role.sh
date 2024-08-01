#!/bin/bash

# NOTE: This script MUST be run from the Management Account

helpFunction()
{
   echo ""
   echo "Usage: $0 -r roleARN -n userFriendlyName"
   echo -e "\t-r : Full ARN of the role we are trying to Assume"
   echo -e "\t-n : User Friendly Name to remember the Assumed Role"
   exit 1 # Exit script after printing help
}

while getopts "r:n:" opt
do
   case "$opt" in
      r ) role_arn="$OPTARG" ;;
      n ) session_name="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$role_arn" ] || [ -z "$session_name" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "Trying to assume Role: $role_arn with Session Name: $session_name"

# Try to Assume the role in child account
sts_response=$(aws sts assume-role --role-arn "$role_arn" --role-session-name "$session_name")

printf "\n"

# Extract the temporary credentials from the response
access_key_id=$(echo "$sts_response" | jq -r '.Credentials.AccessKeyId')
secret_access_key=$(echo "$sts_response" | jq -r '.Credentials.SecretAccessKey')
session_token=$(echo "$sts_response" | jq -r '.Credentials.SessionToken')

# Check if the extraction was successful
if [ -z "$access_key_id" ] || [ -z "$secret_access_key" ] || [ -z "$session_token" ]; then
    echo "Failed to extract temporary credentials from the response."
    exit 1
fi

# Set the temporary credentials as environment variables
export AWS_ACCESS_KEY_ID="$access_key_id"
export AWS_SECRET_ACCESS_KEY="$secret_access_key"
export AWS_SESSION_TOKEN="$session_token"

echo "Temporary credentials have been set successfully."

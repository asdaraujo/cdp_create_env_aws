#!/bin/bash 
set -o nounset

display_usage() { 
    echo "
Usage:
    $(basename "$0") [--help or -h] <prefix> <region>

Description:
    Creates buckets and subdirectory for CDP environment

Arguments:
    prefix:   prefix for your bucket (root will be <prefix>-cdp-bucket)
    region:   region of your bucket
    --help or -h:   displays this help"

}

# check whether user had supplied -h or --help . If yes display usage 
if [[ ( ${1:-x} == "--help") ||  ${1:-x} == "-h" ]] 
then 
    display_usage
    exit 0
fi 


# Check the numbers of arguments
if [  $# -lt 2 ] 
then 
    echo "Not enough arguments!"
    display_usage
    exit 1
fi 

if [  $# -gt 2 ] 
then 
    echo "Too many arguments!"
    display_usage
    exit 1
fi 

prefix=$1
region=$2
bucket=${prefix}-cdp-bucket

if [ $(aws s3api head-bucket --bucket $bucket 2>&1 | wc -l) -gt 0 ] 
then
    aws s3api create-bucket --bucket $bucket --region $region --create-bucket-configuration LocationConstraint=$region > /dev/null 2>&1
fi

aws s3api put-object --bucket $bucket --key $prefix-dl/logs/ > /dev/null 2>&1
aws s3api put-object --bucket $bucket --key $prefix-dl/ranger/audit/ > /dev/null 2>&1
aws s3api put-object --bucket $bucket --key $prefix-dl/dataeng/ > /dev/null 2>&1
aws s3api put-object --bucket $bucket --key $prefix-dl/datasci/ > /dev/null 2>&1



echo '{"bucket": "'$bucket'"}'

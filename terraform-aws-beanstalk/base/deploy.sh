#!/bin/bash
# Script used to deploy applications from Esure G1 acocunt to Esure G2 accounts. The scripts utilises the profiles set in ~/.aws/credentials
#
# The script does 3 things
# 1. Downloads the release candidate file from G1 s3 bucket
# 2. Changes some files in .ebextensions due to the differences between G1 and G2 builds
# 3. Uploads new release candidate to the specified G2 bucket
# 4. Deploys the release candidate to the G2 beanstalk environment
#
# REQUIREMENTS
# .aws/credentials for G1 and G2 accounts
#
# usage: ./deploy.sh application region zip_file source_profile destination_profile destination_bucket

set -e
start=`date +%s`


if [ $# -ne 5 ]; then
    echo 'usage: ./deploy.sh application region zip_file source_profile destination_profile destination_bucket'
    exit 1
fi

# 
declare -A profile_to_account=(["default"]="829070902612" ["dev"]="050690872663" ["test"]="375857942905" ["prep"]="340864205732" ["prod"]="706665555773" ["core"]="319701921293")

# Name of the beanstalk application
application=$1

# AWS Region where app should be deployed e.g. eu-west-1, eu-west-2
region=$2

# The name of the zip file in the s3 bucket 
zip_file=$3

# The profile of the AWS account to copy from s3 source
source_profile=$4

# The profile of the AWS acocunt to copy to s3 destination
destination_profile=$5

# Local file to copy application into
s3_orig_bucket="s3/${application}"

# The label used to deploy to beanstalk
label=$(basename $zip_file .zip)

# convert source profile -> source account id
source_account_id=${profile_to_account[$source_profile]}

# convert destination profile -> destination account id
destination_account_id=${profile_to_account[$destination_profile]}

# Source bukcet location
source_bucket="elasticbeanstalk-${region}-${source_account_id}"

# Destination bucket location
destination_bucket="elasticbeanstalk-${region}-${destination_account_id}"

[[ -d $s3_orig_bucket ]] || mkdir -p $s3_orig_bucket

# Copy zip file from source bucket
echo "aws s3 cp s3://$source_bucket/$application/$zip_file --profile $source_profile"
aws s3 cp s3://$source_bucket/$application/$zip_file $s3_orig_bucket --profile $source_profile

if [[ $source_profile == 'default' ]]
#
# If copying from the G1 account, remove unwanted files and add G2 files
#
then
	# Unzip and change s3 location
	echo "unzipping `pwd`"
	cd $s3_orig_bucket
	unzip $zip_file 
	rm -f $zip_file
	rm -rf .ebextensions/30-elb.config .ebextensions/dns.config
	cp ../../40-ops.config .ebextensions/
	cp ../../50-log.config .ebextensions/

	zip -r $zip_file Dockerrun.aws.json .ebextensions
	cd ../../
fi

# Copy zip file to destination bucket

echo "aws s3 cp $s3_orig_bucket/$zip_file s3://$destination_bucket/$application/$zip_file --profile $destination_profile"
aws s3 cp $s3_orig_bucket/$zip_file s3://$destination_bucket/$application/$zip_file --profile $destination_profile 

# Create a new application version with the zipped up Dockerrun file

echo "aws elasticbeanstalk create-application-version --application-name $application --version-label $version --source-bundle S3Bucket=$destination_bucket/$application,S3Key=$zip_file --profile prep"
aws elasticbeanstalk create-application-version --application-name $application --version-label $label --source-bundle S3Bucket=$destination_bucket,S3Key=$application/$zip_file --profile ${destination_profile}  --region ${region}

# Update the environment to use the new application version
#echo "aws elasticbeanstalk update-environment --environment-name $application-$destination_profile --version-label $label"
echo "Deploying $label to beanstalk environment $application-$destination_profile"
aws elasticbeanstalk update-environment --environment-name $application-$destination_profile --version-label $label --profile $destination_profile

trap "rm -rf $s3_orig_bucket" EXIT

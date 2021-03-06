#!/usr/bin/env bash
# audit_aws_ec
#
# Refer to https://www.cloudconformity.com/conformity-rules/ElastiCache/elasticache-multi-az.html
#.
  RED='\033[0;31m'
  NC='\033[0m'
  GREEN='\033[0;32m'
  BOLD='\033[1m'
  printf "\n\n"
  printf "${BOLD}############\n"
  printf " ElastiCache AUDIT\n"
  printf "############${NC}\n\n"
for  aws_region in ap-south-1 eu-west-2 eu-west-1 ap-northeast-2 ap-northeast-1 sa-east-1 ca-central-1 ap-southeast-1 ap-southeast-2 eu-central-1 us-east-1 us-east-2 us-west-1 us-west-2;do
  caches=`aws elasticache describe-replication-groups --region $aws_region --query 'ReplicationGroups[].ReplicationGroupId' --output text` 
  for cache in $caches; do 
    check=`aws elasticache describe-replication-groups --region $aws_region --replication-group-id $cache --query 'ReplicationGroups[].AutomaticFailover' |grep enabled`
    if [ ! "$check" ]; then
      printf "${RED}ElastiCache $cache is not Multi-AZ enabled${NC}\n"
    else
      printf "${GREEN}ElastiCache $cache is Multi-AZ enabled${NC}\n"
    fi
  done
done

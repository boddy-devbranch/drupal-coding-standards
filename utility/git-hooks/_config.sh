#!/usr/bin/env bash

#
# Update the values of the variables listed below according to your project.
#
TASK_SOURCE="Jira"
TASK_LINK_SAMPLE="#1234: Short description."
TASK_LINK_PATTERN="#[0-9]{1,4}"

#TASK_SOURCE="BitBucket"
#TASK_LINK_SAMPLE="#000"
#TASK_LINK_PATTERN="#[0-9]{1,4}"

BRANCH_PATTERN="[0-9]{1,4}\.-.*"
BRANCH_LINK_SAMPLE="1234\.dev[-short-description]"

# Helpers: color patterns.
RED='\033[0;31m'
NO_COLOR='\033[0m'

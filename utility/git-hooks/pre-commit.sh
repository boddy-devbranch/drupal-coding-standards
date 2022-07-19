#!/usr/bin/env bash
. "$(dirname "$0")"/_config.sh

#
# This script performs code quality checks:
# - PHPCS checks PHP and YAML files.
# - Eslint checks JavaScript files.
# - File modes checks.

### Prepare list of the files in this commit.
FILES=$(git diff --cached --name-only --diff-filter=ACM HEAD)
if [[ "$FILES" == "" ]]; then
  exit 0;
fi

###
### PHPCS section.
###
PHPCS_BIN=./vendor/bin/phpcs

# Do not run the script if phpcs isn't installed.
if [[ ! -f "$PHPCS_BIN" ]]; then
  printf "${RED}PHPCS does not exist on your filesystem.${NO_COLOR}\n"
  echo "Please run 'composer install' to install all dependencies."
  exit 1
fi

# The standards, directories and extensions are configured
# at phpcs.xml.dist in the root folder of the project.
PHPCS_OUTPUT=$($PHPCS_BIN -q --colors --encoding=utf-8 $FILES)

# Check the exit status of the most recently executed foreground pipeline.
if [ $? != 0 ]; then
  printf "\n\n  ${RED}[ERROR] Coding standards checks failed${NO_COLOR} for files in this commit.\n\n"
  echo "${PHPCS_OUTPUT}"
  printf "\n\n  ${RED}[ERROR] Commit failed.${NO_COLOR} Please fix all Coding Standards!\n\n"
  exit 1
fi

###
### ESLint section.
###
NODE_BIN="node"
ESLINT_BIN="./node_modules/.bin/eslint"

# Do not run the script if ESLint isn't installed.
ESLINT_VERSION=$($NODE_BIN $ESLINT_BIN --env-info | grep "Global ESLint version")
if [[ "$ESLINT_VERSION" == "" ]]; then
  printf "${RED}ESLint does not installed on this project.${NO_COLOR}\n"
  echo "Instructions: https://www.drupal.org/node/1955232#s-checking-custom-javascript-with-eslint"
  exit 1
fi

# Get js files (added to commit) to process with ESLint.
ESLINT_FILES=$(echo "$FILES" | grep -E '\.js$')
ESLINT_OUTPUT=$($NODE_BIN $ESLINT_BIN $ESLINT_FILES)

# Check the exit status of the most recently executed foreground pipeline.
if [ $? != 0 ]; then
  printf "\n\n  ${RED}[ERROR] ESLINT checks failed${NO_COLOR} for files in this commit.\n\n"
  echo "${ESLINT_OUTPUT}"
  printf "\n\n  ${RED}[ERROR] Commit failed.${NO_COLOR} Please fix all Coding Standards!\n\n"
  exit 1
fi

###
### File modes section.
###
STATUS=0
for FILE in $FILES; do

  # Ensure the file still exists (i.e. is not being deleted).
  if [ -a $FILE ]; then

    # Ignore .sh files from the check.
    if [ ${FILE: -3} != ".sh" ]; then

      # Ensure the file has the correct mode.
      EXPECTED_MODE="644"
      STAT="$(stat -f "%A" $FILE 2>/dev/null)"
      if [ $? -ne 0 ]; then
        STAT="$(stat -c "%a" $FILE 2>/dev/null)"
      fi
      if [ "$STAT" -ne "$EXPECTED_MODE" ]; then

        EXPECTED_MODE="664"
        if [ "$STAT" -ne "$EXPECTED_MODE" ]; then
          printf "${RED}File modes check failed (should be $EXPECTED_MODE not $STAT):${NO_COLOR} file $FILE \n"
          STATUS=1
        fi
      fi
    fi
  fi
done
exit $STATUS

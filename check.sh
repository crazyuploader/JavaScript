#!/usr/bin/env bash

# Colors
GREEN="\033[1;32m"
NC="\033[0m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RED="\033[0;31m"

# Check if JSHint Available
JSHint="$(command -v jshint)"
if [[ -z "${JSHint}" ]]; then
    echo -e "${YELLOW}JSHint not available, kindly run ${NC}${MAGENTA}'npm install -g jshint'${NC}"
    echo ""
    echo -e "${RED}Exiting...${NC}"
    exit 1
fi

# List all the .js file(s)
echo -e "${GREEN}" "Available files -${NC}"
FILES=0
LIST_FILES="$(find . -path ./.git -prune -o -name '*.js' -print | sed 's|^./||')"
for file in ${LIST_FILES}; do
    echo "$file"
    (( FILES = FILES + 1 ))
done

# Check file(s) with JSHint
echo ""
ERROR_FILES=0
for file in ${LIST_FILES}; do
    echo "Checking '${file}'"
    jshint --verbose "${file}" 1> /dev/null
    ERROR_CODE="${?}"
    if [[ "${ERROR_CODE}" -ne "0" ]]; then
        echo ""
        echo -e "${RED}$(jshint --verbose "${file}")${NC}"
        echo ""
        (( ERROR_FILES = ERROR_FILES + 1 ))
    else
        echo "OK"
    fi
done
echo ""
if [[ "${ERROR_FILES}" -eq "0" ]]; then
    echo -e "Number of file(s) checked: ${GREEN}${FILES}${NC}"
else
    echo -e "Number of file(s) checked: ${RED}${FILES}${NC}"
    exit 1
fi

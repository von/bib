#!/bin/sh
#
# Install a newly created bib.htm into my website development directory
# as well as production and test websites.

# Exit on any error.
set -e

BIB_HTML="bib.html"

WEB_HOST="vwelch.com"
PRODUCTION_WEB_TARGET="www.vonwelch.com/pubs/index.html"
TEST_WEB_TARGET="test.vonwelch.com/pubs/index.html"

DEV_ROOT="${HOME}/develop/www/"
PRODUCTION_DEV_PATH="${DEV_ROOT}/www.vonwelch.com/pubs/index.html"
TEST_DEV_PATH="${DEV_ROOT}/test.vonwelch.com/pubs/index.html"


if test -f ${BIB_HTML} ; then
    :
else
    echo "No file to copy: ${BIB_HTML}"
    exit 1
fi

for dev_file in ${PRODUCTION_DEV_PATH} ${TEST_DEV_PATH} ; do
    echo "Copying ${BIB_HTML} to ${dev_file}"
    cp ${BIB_HTML} ${dev_file}
done

for web_file in ${PRODUCTION_WEB_TARGET} ${TEST_WEB_TARGET} ; do 
    echo "SCP'ing ${BIB_HTML} to ${WEB_HOST}:${web_file}"
    scp ${BIB_HTML} ${WEB_HOST}:${web_file}
done

echo "Success"
exit 0
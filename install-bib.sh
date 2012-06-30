#!/bin/sh
#
# Install a newly created bib.htm into my website development directory

# Exit on any error.
set -e

BIB_HTML="bib.html"

DEV_ROOT="${HOME}/develop/www/"
DEV_PATH="${DEV_ROOT}/www.vonwelch.com/pubs/index.html"


if test -f ${BIB_HTML} ; then
    :
else
    echo "No file to copy: ${BIB_HTML}"
    exit 1
fi

for dev_file in ${DEV_PATH} ; do
    echo "Copying ${BIB_HTML} to ${dev_file}"
    cp ${BIB_HTML} ${dev_file}
done

echo "Success"
exit 0

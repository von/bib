#!/bin/bash

usage()
{
  cat <<-END
Usage: $0 <commit message>

Options:
  -h              Print help and exit.
END
}

# options
force=0

# Leading colon means silent errors, script will handle them
# Colon after a parameter, means that parameter has an argument in $OPTARG
while getopts ":fh" opt; do
  case $opt in
    f) force=1 ;;
    h) usage ; exit 0 ;;
    \?) echo "Invalid option: -$OPTARG" >&2 ;;
  esac
done

shift $(($OPTIND - 1))

if test $# -ne 1 ; then
  echo "Missing commit message."
  exit 1
fi

msg=$1; shift;

set -o errexit

if test ${force} -eq 0 ; then
  echo "Make sure there is nothing pending commit..."
  git diff --cached --exit-code
  echo "Make sure there is nothing pending commit in ~/develop/www.vonwelch.com/..."
  (cd ~/develop/www.vonwelch.com && git diff --exit-code )
fi

echo "Generating new website content..."
make install
git add src/*.conf
if git diff --cached --exit-code ; then
  # Nothing to commit.
  :
else
  git commit -m "${msg}"
  git push
fi

echo "Publishing..."
cd ~/develop/www.vonwelch.com/

~/develop/www.vonwelch.com/publish.sh production
git commit --all -m "${msg}"
git push
echo "Success."
exit 0

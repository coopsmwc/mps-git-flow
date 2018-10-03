#! /usr/bin/env bash

dir=`pwd`
git status $dir  > /dev/null 2>&1
status=$?

if test $status -ne 0
 then
	echo 'You are not in a git enabled repository!'
	exit 1
fi

if [ "$1" = "feature" ] && [ ! -z "$3" ]
 then
    if [ "$2" = "start" ]
     then
        echo "Creating new feature branch feature/$3"
        (cd `pwd` && git checkout -b feature/$3 develop > /dev/null 2>&1)
        echo "All done - on feature/$3 branch :-)"
        exit 1
    fi

    if [ "$2" = "finish" ]
     then
        echo "Switching to the develop branch"
        (cd `pwd` && git checkout develop > /dev/null 2>&1)
        echo "Merging branch feature/$3 into develop"
        (cd `pwd` && git merge feature/$3 > /dev/null 2>&1)
        echo "Removing local branch feature/$3"
        (cd `pwd` && git branch -d feature/$3 > /dev/null 2>&1)
        echo "All done :-)"
        exit 1
    fi
fi

if [ "$1" = "release" ] && [ ! -z "$3" ]
 then
    if [ "$2" = "start" ]
     then
	echo "Creating new branch release/$3"
	(cd `pwd` && git checkout -b release/$3 develop > /dev/null 2>&1)
	echo "Pushing new branch release/$3 to Github"
	(cd `pwd` && git push origin release/$3 > /dev/null 2>&1)
	(cd `pwd` && git checkout develop > /dev/null 2>&1)
	echo "All done - back on develop :-)"
	exit 1
    fi

    if [ "$2" = "finish" ]
     then
	echo "Switching to the master branch"
	(cd `pwd` && git checkout master > /dev/null 2>&1)
        echo "Merging release/$3 into master"
        (cd `pwd` && git merge release/$3 > /dev/null 2>&1)
        echo "Creating a tag for release/$3 and pushing to Github"
        (cd `pwd` && git tag -a "v$3" -m "my version $3" > /dev/null 2>&1 && git push origin "v$3" > /dev/null 2>&1)
        echo "Pushing master to Github"
        (cd `pwd` && git push origin master > /dev/null 2>&1)
        echo "Switching to the develop branch"
        (cd `pwd` && git checkout develop > /dev/null 2>&1)
        echo "Merging release/$3 iback into develop"
        (cd `pwd` && git merge release/$3 > /dev/null 2>&1)
        echo "Pushing develop to Github"
        (cd `pwd` && git push origin develop > /dev/null 2>&1)
        echo "All done - master is pushed for release/$3 and is waiting to be deployed to staging :-)"
        exit 1
    fi
fi

echo 'You must enter a valid command first'
exit 1

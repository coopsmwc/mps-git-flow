#! /usr/bin/env bash

dir=`pwd`
git status $dir  > /dev/null 2>&1
status=$?

if test $status -ne 0
 then
	echo 'You are not in a git enabled repository!'
	exit 1
fi

develop=develop
master=master

if [ "$1" = "feature" ] && [ ! -z "$3" ]
 then
    if [ "$2" = "start" ]
     then
	git flow feature start $3
        echo "All done - on feature/$3 branch :-)"
        exit 1
    fi

    if [ "$2" = "finish" ]
     then
	git flow feature finish $3
	while true; do
    		read -p "Do you want to push $develop to Github?" yn
    		case $yn in
        		[Yy]* ) (cd `pwd` && git push origin $develop); break;;
        		[Nn]* ) exit;;
        		* ) echo "Please answer yes or no.";;
    		esac
	done
        echo "All done :-)"
        exit 1
    fi
fi

if [ "$1" = "release" ] && [ ! -z "$3" ]
 then
    if [ "$2" = "start" ]
     then
	git-flow release start $3
	echo "{\"version\":\"$3\"}" > version.json
	(cd `pwd` && git add . && git commit -a -m "added version file for release $3" > /dev/null 2>&1)
	exit 1
    fi

    if [ "$2" = "finish" ]
     then
	echo "Pushing branch release/$3 to Github"
	(cd `pwd` && git push origin release/$3 > /dev/null 2>&1)
	git-flow release finish $3
	(cd `pwd` && git checkout $develop > /dev/null 2>&1)
        while true; do
                read -p "Do you want to push $develop and $master to Github?" yn
                case $yn in
                        [Yy]* ) (cd `pwd` && git push origin $develop && git push origin $master && git push origin v$3); break;;
                        [Nn]* ) exit;;
                        * ) echo "Please answer yes or no.";;
                esac
        done
	echo "All done - back on $develop :-)"
        exit 1
    fi
fi

echo 'You must enter a valid command first'
exit 1

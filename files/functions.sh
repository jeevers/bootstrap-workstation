function git_update_submodules {
    git submodule foreach "git checkout master; git pull"
}

function git_rebase_branch {
    current_branch=$(git branch | awk '/^\*/ {print $2}')
    if [[ current_branch != "master" ]]
    then
        git checkout master
        git pull
        git checkout $current_branch
        git rebase master
    else
        echo "on branch master already; not doing anything"
    fi
}

function git_update_origin {
    if [[ $1 != "" ]]
    then
        upstream=$1
    else
        upstream=upstream
    fi

    current_branch=$(git branch | awk '/^\*/ {print $2}')

    git checkout master
    git fetch $upstream
    git merge $upstream/master
    git push origin master

    git checkout $current_branch
}

function cdpdump { #will dump CDP packets -- Cisco Only
    if [[ $1 != "" ]] # arg1 is the name of the network interface
    then
        sudo tcpdump -v -s 1500 -i $1 -c 1 'ether[20:2] == 0x2000'
    else
        # listen on default device
        sudo tcpdump -v -s 1500 -c 1 'ether[20:2] == 0x2000'
    fi
}

function lldpdump { #will dump LLDP packets
    if [[ $1 != "" ]] # arg1 is the name of the network interface
    then
        sudo tcpdump -i $1 -s 1500 -XX -c 1 'ether proto 0x88cc'
    else
        # listen on default device
        sudo tcpdump -s 1500 -XX -c 1 'ether proto 0x88cc'
    fi
}

function neighbordump { #will dump either CDP or LLDP packets, whatever comes first
    if [[ $1 != "" ]] # arg1 is the name of the network interface
    then
        sudo tcpdump -i $1 -v -s 1500 -c 1 '(ether[12:2]=0x88cc or ether[20:2]=0x2000)'
    else
        # listen on default device
        sudo tcpdump -v -s 1500 -c 1 '(ether[12:2]=0x88cc or ether[20:2]=0x2000)'
    fi
}

function py3init {
    if [ ! -e ./Pipfile ]
    then
        pipenv --three
    fi

    if  [ ! -e ./.envrc ]
    then
        echo '. $(pipenv --venv)/bin/activate' >> ./.envrc
        direnv allow
    fi
}



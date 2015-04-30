#!/bin/bash
dbname="$1"
NEWPORT=5433
if sudo -u postgres createdb -p $NEWPORT -O dspace $dbname ;then
	echo "Created db $dbname";
else
	echo "Failed to create db $dbname, maybe it exists.";
	echo "Should we drop it?"
	echo "This will run \"sudo -u postgres dropdb -p $NEWPORT $dbname\""
	read -p "Are you sure? [y/n] " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	    # do dangerous stuff
	    sudo -u postgres dropdb -p $NEWPORT $dbname
	    if ! sudo -u postgres createdb -p $NEWPORT -O dspace $dbname;then
		echo "Failed to create db $dbname";
		exit 1;
	    fi
	else
	    echo "Exiting"
	    exit 0;
	fi
fi

sudo -u postgres pg_dump $dbname | sudo -u postgres psql -p $NEWPORT $dbname

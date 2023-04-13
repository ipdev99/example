#!/bin/bash

## Run Magisk snap-shot build.
## ipdev @ xda-developers

# Set main variables
DATE=$(date '+%Y%m%d')
TDIR=$(pwd)

# Set additional variables
BUILD="$TDIR"/snapshot
CURRENT="$TDIR"/snapshot/current
MAGISK="$TDIR"/Magisk
OUT="$TDIR"/Magisk/out
JSON="$TDIR"/magisk-files
SNAPSHOT="$TDIR"/magisk-snapshot


# __ Define functions. __

backup() {
	if [[ -d $CURRENT ]]; then
		BACKUP=$(date -r $CURRENT '+%Y%m%d');
		if [[ -d $BUILD/$BACKUP ]]; then
			MVBACKUP=$(date -r $BUILD/$BACKUP '+%Y%m%d_%H%M');
			mv $BUILD/$BACKUP $BUILD/$MVBACKUP;
			BACKUP=$(date -r $CURRENT '+%Y%m%d_%H%M');
		fi;
		mv $CURRENT $BUILD/$BACKUP;
		echo "- Backup "$BUILD"/"$BACKUP;
	fi;
}

check_apk_file() {
	if [[ ! "$(find "$OUT" -name '*debug.apk')" ]]; then
		echo "Debug Build - Not Found."
		echo " Fail."; echo ""
		exit 1;
	elif [[ ! "$(find "$OUT" -name '*release.apk')" ]]; then
		echo "Release Build - Not Found."
		echo " Fail."; echo ""
		exit 1;
	fi
}

notes_md() {
	echo "## Magisk ("$SHEAD"-ip) ("$VCODE")" >$CURRENT/notes.md;
	echo "" >>$CURRENT/notes.md;
	echo "- Snapshot of Magisk _"$SHEAD"_" >>$CURRENT/notes.md;
        # echo "- _"$(date --utc)"_" >>$CURRENT/notes.md;
}

pull_update() {
	i=$(git rev-parse --short HEAD);
	# git pull --recurse-submodules=yes --verbose;
	git pull --recurse-submodules=yes --quiet;
	ii=$(git rev-parse --short HEAD);
	[[ $ii != $i ]] && SHEAD=$ii;
}

set_config_prop() {
	echo "# All variables in config.prop are optional" >config.prop;
	echo "# Removing or leaving them blank will keep default values" >>config.prop;
	echo "" >>config.prop;
	echo "# The version name of Magisk. Default: git HEAD short SHA1" >>config.prop;
	echo "# git rev-parse --short HEAD" >>config.prop;
	echo "version="$SHEAD"-ip" >>config.prop;
	echo "" >>config.prop;
	echo "# Output path. Default: out" >>config.prop;
	echo "## outdir="$CURRENT"" >>config.prop;
	echo "## Currently breaks the build setting an alternative out directory." >>config.prop;
	echo "" >>config.prop;
	echo "" >>config.prop;
	echo "# Signing configs for signing zips and APKs" >>config.prop;
	echo "# These 4 variables has to be either all set or not" >>config.prop;
	echo "" >>config.prop;
	echo "# Path to keystore file" >>config.prop;
	echo "keyStore=/home/ip/github/magisk_key/magisk_keystore.jks" >>config.prop;
	echo "# Keystore password" >>config.prop;
	echo "keyStorePass=xxxx" >>config.prop;
	echo "# The desired key alias in the keystore" >>config.prop;
	echo "keyAlias=xxxx" >>config.prop;
	echo "# Password of specified key alias" >>config.prop;
	echo "keyPass=xxxx" >>config.prop;
}

snap_shot_json() {
	echo "{" >$JSON/snapshot.json;
	echo "  \"magisk\": {" >>$JSON/snapshot.json;
	echo "    \"version\": \""$SHEAD"-ip\"," >>$JSON/snapshot.json;
	echo "    \"versionCode\": \""$VCODE"\"," >>$JSON/snapshot.json;
	echo "    \"link\": \"https://cdn.jsdelivr.net/gh/ipdev99/magisk-files@"$COMMIT"/app-release.apk\"," >>$JSON/snapshot.json;
	echo "    \"note\": \"https://cdn.jsdelivr.net/gh/ipdev99/magisk-files@"$COMMIT"/notes.md\"" >>$JSON/snapshot.json;
	echo "  }," >>$JSON/snapshot.json;
	echo "  \"stub\": {" >>$JSON/snapshot.json;
	echo "    \"versionCode\": \""$SVCODE"\"," >>$JSON/snapshot.json;
	echo "    \"link\": \"https://cdn.jsdelivr.net/gh/ipdev99/magisk-files@"$COMMIT"/stub-release.apk\"" >>$JSON/snapshot.json;
	echo "  }" >>$JSON/snapshot.json;
	echo "}" >>$JSON/snapshot.json;
}

snap_shot_debug_json() {
	echo "{" >$JSON/sdebug.json;
	echo "  \"magisk\": {" >>$JSON/sdebug.json;
	echo "    \"version\": \""$SHEAD"-ip\"," >>$JSON/sdebug.json;
	echo "    \"versionCode\": \""$VCODE"\"," >>$JSON/sdebug.json;
	echo "    \"link\": \"https://cdn.jsdelivr.net/gh/ipdev99/magisk-files@"$COMMIT"/app-debug.apk\"," >>$JSON/sdebug.json;
	echo "    \"note\": \"https://cdn.jsdelivr.net/gh/ipdev99/magisk-files@"$COMMIT"/notes.md\"" >>$JSON/sdebug.json;
	echo "  }," >>$JSON/sdebug.json;
	echo "  \"stub\": {" >>$JSON/sdebug.json;
	echo "    \"versionCode\": \""$SVCODE"\"," >>$JSON/sdebug.json;
	echo "    \"link\": \"https://cdn.jsdelivr.net/gh/ipdev99/magisk-files@"$COMMIT"/stub-debug.apk\"" >>$JSON/sdebug.json;
	echo "  }" >>$JSON/sdebug.json;
	echo "}" >>$JSON/sdebug.json;
}


# __ Lets Go. __

# Magisk

cd $MAGISK
echo ""; echo "Current Magisk version : $(git rev-parse --short HEAD)";
pull_update

## Force a build by setting SHEAD manually.
# SHEAD=$(git rev-parse --short HEAD)

if [[ -n $SHEAD ]]; then

	# Set versionCode variables.
	VCODE=$(cat gradle.properties | grep 'magisk.versionCode' | cut -d '=' -f2)
	SVCODE=$(cat gradle.properties | grep 'magisk.stubVersion' | cut -d '=' -f2)

	# Backup previous build.
	backup

	echo " - Building Magisk version : $SHEAD";

	# Create new config.prop file.
	set_config_prop

	# Make clean.
	python3 build.py clean

	# Install/upgrade NDK.
	python3 build.py ndk

	# Run Debug build.
	python3 build.py all

	# Run release build.
	python3 build.py --release all

	# Exit if no apk files exist.
	check_apk_file

	# Move out to current.
	[[ ! -d $CURRENT ]] && mkdir -p $CURRENT
	for i in $OUT/*; do
		mv $i $CURRENT
	done

	# Create note.md file.
	notes_md

	# Copy to snapshot repo directory.
	for i in $CURRENT/*; do
		cp $i $SNAPSHOT
	done
fi

cd $TDIR

# Snapshot

if [[ -n $SHEAD ]]; then

	# Sync magisk-files
	cd $JSON
	git pull -q

	# Switch to snapshot
	cd $SNAPSHOT

	# Push new snapshot build.
	git add .
	git commit -m 'Snapshot: Upstream to '$SHEAD''
	git push

	# Set snapshot commit.
	COMMIT=$(git rev-parse HEAD)

	# Make new json file.
	snap_shot_json
	snap_shot_debug_json

	# Copy new json file to the current snapshot build directory.
	cp $JSON/snapshot.json $CURRENT
	cp $JSON/sdebug.json $CURRENT

	# Push new json file.
	cd $JSON
	git add snapshot.json
	git add sdebug.json
	git commit -m 'Snapshot: Upstream to '$SHEAD''
	git push

	cd $TDIR
fi


# No change.
[[ ! $SHEAD ]] && echo "- No Change."

# Finish script.
echo ""; echo " Done."; echo "";
exit 0;

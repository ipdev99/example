# If a user config file exists. Copy and convert it to a temporary file.
# Using the 'sed' command
#  Remove lines starting with '#' since it is only a comment line.
#  Lines that contain '#' remove the comment part of the line.
#  Remove double quotes if exist.
#  Remove tab spacing if exist..
#  Remove extra spaces if exist.

# In the 'add_user_config' function.
# Using the 'grep' command to check for an entry in the temporary file.
#  Then use the 'sed' command to remove it from the temporary file.
# Remove the temporary file when done with it.

# Set functions

add_user_config(){
	if grep -q 'VerboseLog' tmp_config; then
		echo "VerboseLog=\"true\"" >> SystemlessDebloaterList.sh
		sed -i -e '/VerboseLog/d' tmp_config
		echo "" >> SystemlessDebloaterList.sh
	fi

	if grep -q 'MultiDebloat' tmp_config; then
		echo "MultiDebloat=\"true\"" >> SystemlessDebloaterList.sh
		sed -i -e '/MultiDebloat/d' tmp_config
		echo "" >> SystemlessDebloaterList.sh
	fi

	if [ -f tmp_config ]; then
		echo "DebloatList=\"" >> SystemlessDebloaterList.sh
		while read i; do 
			echo $i >> SystemlessDebloaterList.sh
		done < tmp_config
		echo "\"" >> SystemlessDebloaterList.sh
		rm tmp_config
	fi
}

new_debloater_list(){
	echo "# Source list for Systemless Debloater (REPLACE)" > SystemlessDebloaterList.sh
	echo "# Copyright (c) zgfg @ xda, 2020-2022" >> SystemlessDebloaterList.sh
	echo "" >> SystemlessDebloaterList.sh
}


# Time to run.

if [ -f sDebloat_config ]; then
	sed -e '/^#/d' -e 's/#.*//g' -e 's/\"//g' -e 's/[ \t ]//g' -e '/^\s*$/d' "sDebloat_config" > "tmp_config"
	new_debloater_list
	add_user_config
fi

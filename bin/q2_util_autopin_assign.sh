#!/usr/bin/env bash

#
# Make Quartus auto pin assigned file, from pin file '*.pin' and auxiliary file
# NOTE: auxiliary file to work with capture

echo "+------------------------------------------------------------------------+"
echo "| Make Quartus auto pin assigned file, from pin file '*.pin'             |"
echo "+------------------------------------------------------------------------+"

fname=`ls *.pin`
fname_out_tmp="$fname,tmp"
fname_out_tmp1="$fname,tmp,1"
fname_out="$fname,1"
fname_out_aux="$fname,aux"

echo "Input file: '$fname'"

TODAY=`date +%Y-%m-%d\ %H:%M:%S`
# TODAY=`date`
write_title2file () {
    str="+-------------------------------------------------------------------------------------------------
| Quartus auto pin assignment
| NOTE: this file was crated by script '$0' at
| $TODAY
+-------------------------------------------------------------------------------------------------"
    echo "$str" > $fname_out
}

cat $fname \
    | grep -v Version \
    | grep -v ASSIGNED \
    | grep -v Location \
    | grep -v power \
    | grep -v gnd \
    | grep -v GND+ \
    | grep -v TMS \
    | grep -v TCK \
    | grep -v nCE \
    | grep -v TDO \
    | grep -v TDI \
    | grep -v CONF_DONE \
    | grep -v MSEL \
    | grep -v nCONFIG \
    | grep -v nSTATUS \
    | grep -v -e '~ALTERA_DCLK~' \
    | grep -v -e '--' \
    | grep -v RESERVED_INPUT_WITH_WEAK_PULLUP \
    | grep -v RESERVED_OUTPUT_OPEN_DRAIN \
    | sed '/ *#/d; /^$/d' > $fname_out_tmp

cat $fname_out_tmp \
    | grep -v -e '(n)' \
    | awk '{printf("set_location_assignment PIN_%s -to %s\n", $3, $1)}' > $fname_out_tmp1
cat $fname_out_tmp \
    | grep -e '(n)' \
    | awk '{printf("set_location_assignment PIN_%s -to \"%s\"\n", $3, $1)}' >> $fname_out_tmp1

write_title2file
cat $fname_out_tmp1 \
    | sort -d -k 4 >> $fname_out

cat $fname_out_tmp \
    | sort -d -k 1 \
    | tr a-z A-z \
    | sed 's/(//g' \
    | sed 's/)//g' \
    | sed 's/\[//g' \
    | sed 's/\]//g' > $fname_out_aux

rm -rf $fname_out_tmp $fname_out_tmp1

echo "Write file: '$fname_out'"
echo "Write file: '$fname_out_aux'"
echo "Done!"

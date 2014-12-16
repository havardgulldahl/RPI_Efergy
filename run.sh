#!/bin/bash
# a script to run the data collection from your Efergy thingie and store the
# readings 
#
# (C) havard@gulldahl.no 2014
# PUBLIC DOMAIN


#config
RECEIVER_GAIN=28.0
EFERGY_INTERVAL=18 # seconds
RECEIVER_FREQUENCY=


RAWDB=readings.rrd
TARRIFFDB=tarriffs.rrd

# inspired from http://sergray.me/energy-monitoring-with-python.html
# check if databases exist
if [ ! -f "$RAWDB" ]; then
    # keeping the actual values added every $EFERGY_INTERVAL seconds and
    # aggregated with 5 minute resolution for last 2 days and 1 hour resolution
    # for 28 days
    rrdtool create "$RAWDB" --step $EFERGY_INTERVAL \
    DS:kW:GAUGE:120:0:300 \
    RRA:AVERAGE:0.5:5:576 \
    RRA:MAX:0.5:5:576 \
    RRA:AVERAGE:0.5:60:672 \
    RRA:MAX:0.5:60:672
fi

if [ ! -f "$TARRIFFDB" ]; then
    # and another one for tracking last values of readings on display added
    # every 10 minutes and aggregated with 1 hour resolution for 2 weeks and 1
    # day resolution for the last year:
    rrdtool create tariffs.rrd  --step 600 \
    DS:tariff1:GAUGE:1200:0:U \
    DS:tariff2:GAUGE:1200:0:U \
    RRA:LAST:0.5:6:336 \
    RRA:LAST:0.5:144:366
fi


OLDIFS="$IFS";
IFS=","

rtl_fm -f 433.55e6 -s 192e3 -r 96e3 -g $RECEIVER_GAIN -p 25 |
./EfergyRPI_001 |
while read DATE TIME USAGE; 
do
    test "$USAGE" || continue; # skip empty readings
    echo "--D: $DATE --T: $TIME --U: $USAGE --";
    rrdtool update "$RAWDB" N:$USAGE;
done
    

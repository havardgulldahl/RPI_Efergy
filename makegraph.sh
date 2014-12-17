#!/bin/bash
# from https://gist.github.com/sergray/1d2572f9646d79711518
# by http://sergray.me/energy-monitoring-with-python.html
rrdtool graph W.png --vertical-label=W*h --font=DEFAULT:11:Arial -w 900 -h 600 \
DEF:akw=readings.rrd:WATT:AVERAGE CDEF:wkw=akw,1,\* LINE2:wkw#FF0000

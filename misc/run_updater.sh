#!/bin/bash

cd /home/fzurell/temp_logger
/usr/bin/python update_rrd.pyc
/home/fzurell/temp_logger/generate_graph.sh

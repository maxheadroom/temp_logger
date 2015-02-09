#!/bin/bash

cd /home/fzurell/temp_logger
/usr/bin/python update_rrd.pyc
/usr/bin/python misc/create_graph.pyc

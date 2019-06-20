#!/bin/bash
rm -f /var/run/httpd/httpd.pid
exec httpd -DFOREGROUND "$@"

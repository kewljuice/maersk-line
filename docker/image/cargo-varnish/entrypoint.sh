#!/bin/sh
varnishd -F -f /etc/varnish/default.vcl -s malloc,${VARNISH_MEMORY} -a 0.0.0.0:${VARNISH_HTTP_PORT} -a 0.0.0.0:${VARNISH_HTTP_ADMIN_PORT} -T 0.0.0.0:${VARNISH_ADMIN_PORT}

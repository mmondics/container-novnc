#!/bin/sh

ENDPOINT=${ENDPOINT:-localhost}
PORT=${PORT:-5900}

AUTOCONNECT=${AUTOCONNECT:-true}
VNC_PASSWORD=${VNC_PASSWORD:-openshift}
# VIEW_ONLY=false

sed -i "/wait ${proxy_pid}/i if [ -n \"\$AUTOCONNECT\" ]; then sed -i \"s/'autoconnect', false/'autoconnect', '\$AUTOCONNECT'/\" /app/noVNC/app/ui.js; fi" /app/noVNC/utils/novnc_proxy
sed -i "/wait ${proxy_pid}/i if [ -n \"\$VNC_PASSWORD\" ]; then sed -i \"s/WebUtil.getConfigVar('password')/'\$VNC_PASSWORD'/\" /app/noVNC/app/ui.js; fi" /app/noVNC/utils/novnc_proxy
sed -i "/wait ${proxy_pid}/i if [ -n \"\$VIEW_ONLY\" ]; then sed -i \"s/UI.rfb.viewOnly = UI.getSetting('view_only');/UI.rfb.viewOnly = \$VIEW_ONLY;/\" /app/noVNC/app/ui.js; fi" /app/noVNC/utils/novnc_proxy

if [ -z "$@" ]; then
  exec  /app/noVNC/utils/novnc_proxy --listen 8080 --vnc "${ENDPOINT}:${PORT}"
else
  exec "$@"
fi

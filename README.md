# NoVNC Container

Allow a VNC connection with a web browser

## Quick start

Build locally

```
docker build -t novnc .
```

Deploy On OpenShift

```
oc new-app https://github.com/codekow/container-novnc.git \
  --name=novnc \
  -e ENDPOINT=hostname \
  -e PORT=5900 \
  -e PASSWORD=openshift
```

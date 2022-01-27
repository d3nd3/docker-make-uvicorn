#!/bin/bash
<< 'explained'
The command uvicorn main:app refers to:

main: the file main.py (the Python "module").
app: the object created inside of main.py with the line app = FastAPI().
--reload: make the server restart after code changes. Only use for development.
explained

#production
#uvicorn --uds /tmp/uvicorn.sock --forwarded-allow-ips='*' app.myapp:app &
#dev
#/proc/1/fd/1 ensures output to docker logs
uvicorn --reload uvicornn.appdir.entry:app > /proc/1/fd/1 &
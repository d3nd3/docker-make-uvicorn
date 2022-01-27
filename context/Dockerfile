from nginx
RUN apt -y update && apt -y full-upgrade && apt -y install uvicorn
RUN apt -y install python3-fastapi

WORKDIR /docker-work

#NGINX 1.19 has a folder /docker-entrypoint.d for startup scripts
#enable running of uvicorn.
COPY nginx.conf /etc/nginx/nginx.conf
COPY start_uvicorn.sh /docker-entrypoint.d/40-start-uvicorn.sh
RUN chmod +x /docker-entrypoint.d/40-start-uvicorn.sh

#RUN apt -y install procps
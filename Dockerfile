FROM ubuntu:latest
ARG MY_FLASK_PORT
ENV MY_FLASK_PORT=${MY_FLASK_PORT}
RUN apt-get update -y \
  && apt-get install -y python3-pip python3-dev build-essential
COPY . /app
WORKDIR /app
RUN pip3 install -r requirements.txt
ENTRYPOINT ["python3"]
CMD ["app.py"]

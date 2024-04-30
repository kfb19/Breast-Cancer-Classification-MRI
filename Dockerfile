FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install python3 -y \
    && apt-get install python3-pip -y \
    && apt-get install git -y


RUN mkdir -p /backend
WORKDIR /backend
COPY ./requirements.txt /backend
COPY ./Backend /backend 

RUN pip3 install -r requirements.txt
RUN pip3 install psycopg2-binary
RUN pip3 install torch
RUN pip3 install torchvision
RUN pip3 install tzdata

RUN python3 django/breastwise/app/manage.py migrate

WORKDIR /backend/django/breastwise/app
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
FROM ubuntu:bionic as build
RUN apt-get update && \
    apt-get install cmake make gcc g++ -y
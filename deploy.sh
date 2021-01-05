#!/bin/bash

# build images
docker build -t gowthamyadav/multi-client:latest -t gowthamyadav/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t gowthamyadav/multi-server:latest -t gowthamyadav/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t gowthamyadav/multi-worker:latest  -t gowthamyadav/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push images to dockerhub
docker push gowthamyadav/multi-client:latest
docker push gowthamyadav/multi-server:latest
docker push gowthamyadav/multi-worker:latest

docker push gowthamyadav/multi-client:$SHA
docker push gowthamyadav/multi-server:$SHA
docker push gowthamyadav/multi-worker:$SHA

# apply k8s config files for deployment and services
kubectl apply -f k8s

# upgrader images to latest
kubectl set image deployment/client-deployment client=gowthamyadav/multi-client:$SHA
kubectl set image deployment/server-deployment server=gowthamyadav/multi-server:$SHA
kubectl set image deployment/worker-deployment worker=gowthamyadav/multi-worker:$SHA

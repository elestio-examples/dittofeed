#!/usr/bin/env bash
cp -rf packages/dashboard/* ./
docker buildx build . --output type=docker,name=elestio4test/dittofeed-dashboard:latest | docker load

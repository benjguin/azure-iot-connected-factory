#!/bin/bash
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

# this script is meant to be run from a container built with Dockerfile-linux-simulation

# create log and cert folder
mkdir /app/logs

# run Factory
echo "run Factory"
cd /app/Station
nohup nice dotnet Station.dll Munich/ProductionLine0/Assembly opc.tcp://0.0.0.0:51210 200 35 "yes" 1> /app/logs/assembly-station.out 2> /app/logs/assembly-station.err < /dev/null &
nohup nice dotnet Station.dll Munich/ProductionLine0/Test opc.tcp://0.0.0.0:51214 100 30 no 1> /app/logs/test-station.out 2> /app/logs/test-station.err < /dev/null &
nohup nice dotnet Station.dll Munich/ProductionLine0/Packaging opc.tcp://0.0.0.0:51215 150 20 no 1> /app/logs/package-station.out 2> /app/logs/package-station.err < /dev/null &

# wait until the OPC servers started fully up
echo "Waiting 10s for stations to start up"
sleep 10
echo "Start MES"

cd /app/MES
nohup nice dotnet MES.dll 1> /app/logs/MES.out 2> /app/logs/MES.err </dev/null &

cd /app

echo "Factory running"
jobs

echo Factory Jobs started

read -p "press ENTER to exit" userResponse

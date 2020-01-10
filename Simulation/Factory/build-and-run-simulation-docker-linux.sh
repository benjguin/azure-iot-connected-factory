#!/bin/bash
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

build_root=$(cd "$(dirname "$0")" && pwd)
cd $build_root

docker build -t cfsimulation:1.0 --file Dockerfile-linux-simulation .
docker run --rm -it cfsimulation:1.0

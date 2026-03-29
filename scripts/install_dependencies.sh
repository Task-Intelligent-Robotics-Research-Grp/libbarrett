#!/usr/bin/env bash
# This script installs libbarrett dependencies

# Import the Linux Version Number Variables

# Install CAN scripts
sudo cp reset_can.sh /bin
sudo cp 60-can.rules /etc/udev/rules.d
sudo udevadm control --reload-rules && udevadm trigger

# Install libbarrett dependencies
sudo apt update
sudo apt install -y git cmake clang net-tools can-utils
sudo apt install -y libgsl-dev libeigen3-dev libncurses-dev pkg-config
sudo apt install -y libboost-system-dev libboost-thread-dev libboost-python-dev

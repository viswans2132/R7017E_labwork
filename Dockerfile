FROM ubuntu:24.04

# Install APT packages
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \ 
    curl \
    gnupg \
    git \
    sudo \
    wget \
    lsb-release \
    software-properties-common \
    tmux \
    unzip \
    zip \
    gcc \
    g++ \
    cmake \
    python3-pip \
    python3-venv \
    nano
RUN apt-get clean all


# Install ROS2 jazzy
RUN add-apt-repository universe
RUN apt update
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt update
RUN apt upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-desktop
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-tf-transformations ros-jazzy-tf2-geometry-msgs
RUN DEBIAN_FRONTEND=noninteractive apt install -y python3-colcon-common-extensions

# Change the Working Directory
WORKDIR /ros_ws

# Install Gazebo
RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
RUN apt update
RUN apt install gz-harmonic -y




# Install ROS packages for controlling the Gazebo environment
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-ros-gz-sim
# RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-gz-msgs
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-ros-gz-bridge
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-xacro
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-control-msgs 
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-backward-ros 
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-realtime-tools 
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-control-toolbox 
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-ros2-control
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-ros2-controllers
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-gz-ros2-control
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-joint-state-broadcaster
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-jazzy-joint-trajectory-controller

# Install Text Editor
RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
RUN echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
RUN apt-get update

# Install RUST and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN echo 'source $HOME/.cargo/env' >> ~/.bashrc

# Install optimizer and other tools
RUN python3 -m venv .venv \
 && . .venv/bin/activate \
 && pip install --upgrade pip \
 && pip install --upgrade cvxpy transforms3d vcstool
# RUN DEBIAN_FRONTEND=noninteractive apt install -y liblcm-dev

RUN echo 'source /opt/ros/jazzy/setup.bash' >> ~/.bashrc 
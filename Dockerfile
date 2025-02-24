FROM ubuntu:22.04

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
    nano
RUN apt-get clean all


# Install ROS2 humble
RUN add-apt-repository universe
RUN apt update
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt update
RUN apt upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-desktop
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-tf-transformations ros-humble-tf2-geometry-msgs
RUN DEBIAN_FRONTEND=noninteractive apt install -y python3-colcon-common-extensions

# Change the Working Directory
WORKDIR /ros_ws

# Install Gazebo
RUN curl -sSL http://get.gazebosim.org | sh
RUN DEBIAN_FRONTEND=noninteractive apt-get install ros-humble-gazebo-ros-pkgs -y

# Install ROS packages for controlling the Gazebo environment
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-xacro
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-control-msgs 
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-backward-ros 
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-realtime-tools 
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-control-toolbox 
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-ros2-control
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-ros2-controllers
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-gazebo-ros2-control
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-joint-state-broadcaster
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-joint-trajectory-controller

# Install Text Editor
RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
RUN echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
RUN apt-get update

# Install RUST and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN echo 'source $HOME/.cargo/env' >> ~/.bashrc

# Install optimizer and other tools
RUN pip3 install --upgrade opengen
RUN pip3 install --upgrade transforms3d vcstool
# RUN DEBIAN_FRONTEND=noninteractive apt install -y liblcm-dev

RUN echo 'source /opt/ros/humble/setup.bash' >> ~/.bashrc 
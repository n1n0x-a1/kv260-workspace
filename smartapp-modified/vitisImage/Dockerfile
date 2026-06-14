FROM xilinx/vitis-ai:2.5

RUN sudo apt update

RUN sudo apt install sshpass -y

ADD ssh_config /

RUN sudo cp -f /ssh_config /etc/ssh/

WORKDIR /home/workspace

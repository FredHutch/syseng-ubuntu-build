FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get -qq update
RUN apt-get -qq install curl \
                        gnupg gnupg2 \
                        apt-utils \
                        git \
                        sudo \
                        wget \
                        python python-pip \
                        python3 python3-pip \
                        jq \
                        make \
                        gcc \
                        vim nano\
                        rsync \
                        unzip zip \
                        apt-transport-https lsb-release software-properties-common dirmngr \
                        awscli
                        
WORKDIR /root

# Install docker-compose
RUN curl -sL "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install docker client
RUN curl -sL https://download.docker.com/linux/static/stable/x86_64/docker-18.06.1-ce.tgz -o docker.tar.gz && \
    tar -zxf docker.tar.gz && cp docker/docker /usr/local/bin/ && rm -rf docker && rm docker.tar.gz

# Install Chef Workstation (replaces ChefDK)
RUN curl -Ls https://packages.chef.io/files/stable/chef-workstation/0.2.48/ubuntu/18.04/chef-workstation_0.2.48-1_amd64.deb -o chef-workstation.deb && \
    dpkg -i chef-workstation.deb && apt-get -qq install -f && rm chef-workstation.deb

# Install Golang 1.11
RUN curl -sL https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz -o go.tar.gz && \
    tar -zxf go.tar.gz && mv go /usr/local && rm -rf go && rm go.tar.gz && echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

# Install Terraform 
RUN curl -sL https://releases.hashicorp.com/terraform/0.12.7/terraform_0.12.7_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && mv terraform /usr/local/bin && rm terraform.zip

# Install Vagrant 
RUN curl -sL https://releases.hashicorp.com/vagrant/2.2.3/vagrant_2.2.3_x86_64.deb -o vagrant.deb && \
    dpkg -i vagrant.deb && apt-get -qq install -f && rm vagrant.deb

# Install Azure CLI
RUN curl -sL https://packages.microsoft.com/repos/azure-cli/pool/main/a/azure-cli/azure-cli_2.0.56-1~bionic_all.deb -o azure-cli.deb && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -  && \
    dpkg -i azure-cli.deb && rm azure-cli.deb

# Install Packer 
RUN curl -sL https://releases.hashicorp.com/packer/1.3.4/packer_1.3.4_linux_amd64.zip -o packer.zip && \
    unzip packer.zip && mv packer /usr/local/bin && rm packer.zip

# Install PowerShell Core 6.1
RUN apt-get install -y libssl1.0.0 libicu60 liblttng-ust0 && \
    curl -sL https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/powershell_6.1.2-1.ubuntu.18.04_amd64.deb -o pwsh.deb && \
    dpkg -i pwsh.deb && apt-get -qq install -f && rm pwsh.deb

# Install latest Ansible
RUN apt-add-repository --yes --update ppa:ansible/ansible && apt-get -qq install ansible 

# Install Nodejs 10.15 LTS
RUN curl -sL https://nodejs.org/dist/v10.15.1/node-v10.15.1-linux-x64.tar.xz -o nodejs.tar.xz && \
    mkdir -p /usr/local/lib/nodejs && \
    tar -xJf nodejs.tar.xz -C /usr/local/lib/nodejs && rm -rf nodejs.tar.xz && \
    echo "export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/usr/local/lib/nodejs/node-v10.15.1-linux-x64/bin" >> ~/.bashrc

# Install Terragrunt
RUN curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v0.18.2/terragrunt_linux_amd64 -o terragrunt && \
    chmod +x terragrunt && \
    cp terragrunt /usr/local/bin/

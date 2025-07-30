
Dániel Ernő Szabó,
Mon 3:09 PM
,
https://docs.github.com/en/actions/get-started/quickstart
Quickstart for GitHub Actions - GitHub Docs
Quickstart for GitHub Actions - GitHub Docs
docs.github.com
, Mon 3:09 PM
,
Dániel Ernő Szabó,
Mon 3:22 PM
,
use axum::{response::Html, routing::get, Router};

#[tokio::main]
async fn main() {
    let app = Router::new().route("/", get(handler));
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await.unwrap();
    println!("listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app).await.unwrap();
}

async fn handler() -> Html<&'static str> {
    Html("<h1>Welcome to Axum webapp built with GH Actions! /rust</h1>")
}
, Mon 3:22 PM
,
Dániel Ernő Szabó,
Mon 3:26 PM
,
https://hub.docker.com
Docker Hub Container Image Library | App Containerization
Docker Hub Container Image Library | App Containerization
hub.docker.com
, Mon 3:26 PM
,
Dániel Ernő Szabó,
Mon 3:33 PM
,
name: Build and push Docker image to dockerhub

on:
  push:
    branches: [ "main" ]
    
jobs:

  build:

    runs-on: ubuntu-latest

    steps:
    - name: Check out the repo
      uses: actions/checkout@v4

    - name: Login to dockerhub
      uses: docker/login-action@v3
      with:
       username: ${{ secrets.DOCKERHUB_USERNAME }}
       password: ${{ secrets.DOCKERHUB_TOKEN }}

    - name: Build and push to dockerhub
      uses: docker/build-push-action@v5
      with:
       context:
       push: true
       tags: r3ap3rpy/nix-gh-docker:latest
, Mon 3:33 PM
,
Dániel Ernő Szabó,
Mon 4:14 PM
,
https://github.com/actions/runner-images
GitHub - actions/runner-images: GitHub Actions runner images
GitHub - actions/runner-images: GitHub Actions runner images
github.com
, Mon 4:14 PM
,
Install ansible
, Mon 4:15 PM
,
name: Prepare runner for Ansible

on:
  workflow_dispatch:

jobs:
  prepare-runner:
    name: "Prepare runner with pip and Ansible"
    runs-on: self-hosted

    steps:
      - name: Ensure pip is installed
        run: |
          curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
          python3 get-pip.py --user

      - name: Add pip user bin to PATH
        run: echo "$HOME/.local/bin" >> $GITHUB_PATH

      - name: Install Ansible
        run: pip3 install --user ansible

      - name: Check ansible version
        run: ansible --version
, Mon 4:15 PM
,

test ansible
, Mon 4:15 PM
,

name: Test Playbook

on:
  workflow_dispatch:

jobs:
  run-playbook:
    runs-on: self-hosted

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Verify Ansible is installed
        run: ansible --version
      - name: Check directory
        run: ls -l
      - name: Run demo_playbook.yml
        run: ansible-playbook demo_playbook.yaml
, Mon 4:15 PM
,

demo_playbook.yaml
, Mon 4:16 PM
,

---

    hosts: localhost

  tasks:
  - name: "Uptime"
    shell: uptime
, Mon 4:16 PM
,
Dániel Ernő Szabó,
Mon 5:32 PM
,
first.yml
, Mon 5:32 PM
,
# .github/workflows/build.yml
name: First

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "First workflow "
, Mon 5:32 PM
,

second.yml
, Mon 5:32 PM
,

name: Second

on:
  workflow_run:
    workflows: ["First"]
    types:
      - completed

jobs:
  test:
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    runs-on: ubuntu-latest
    steps:
      - run: echo "Running after first workflow!"
, Mon 5:32 PM
,
Yesterday
Dániel Ernő Szabó,
Yesterday 11:07 AM
,
Sziasztok, kövi hétfőre a ház haladni az LMS checkekkel a centos és ubuntu 3. adagja legyen meg illetve a final projectből az ansible rész
, Yesterday 11:07 AM
,
Unread
Today
Dániel Ernő Szabó,
9 min
,
backup.yml
, 9 min
,
name: Backup folder
on:
  push:
    paths:
      - 'backup/**'

jobs:
  handle-api:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Backup folder changed!"
, 9 min
,

docker.yml
, 9 min
,

name: Docker folder
on:
  push:
    paths:
      - 'docker/**'

jobs:
  handle-api:
    runs-on: ubuntu-latest
    steps:
    - run: echo "docker folder changed!"
, 9 min
,
Dániel Ernő Szabó,
1 min
,

main.tf
, 1 min
,

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.az
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.az

}
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet.id
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}
resource "aws_route_table_association" "public_subnet_rt_assocation" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}
resource "aws_route_table_association" "private_subnet_rt_assocation" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main_vpc.id
  
 ingress=[                
   {
description      = ""
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     security_groups  = []
     self             = false
     cidr_blocks      = [ "0.0.0.0/0", ]
     from_port        = 80
     protocol         = "tcp"
     to_port          = 80
  }]
  
  egress = [
{
description      = ""
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     security_groups  = []
     self             = false
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0",]
}
]
}
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main_vpc.id
 ingress                = [
   { 
description      = ""
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     security_groups  = []
     self             = false
     cidr_blocks      = [ var.vpc_cidr, ]
     from_port        = 22
     protocol         = "tcp"
     to_port          = 22
  }
  ]
  egress = [
{

description      = ""
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     security_groups  = []
     self             = false
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0",]
}
]
}
resource "aws_eip" "nat_eip" {
}
, 1 min
,

outputs.tf
, Now
,

output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.main_vpc.id
}
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value = aws_subnet.public_subnet.id
}
output "private_subnet_id" {
  description = "The ID of the private subnet"
  value = aws_subnet.private_subnet.id
}
output "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  value = aws_nat_gateway.nat_gw.id
}
output "public_security_group_id" {
  description = "The ID of the public security group"
  value = aws_security_group.public_sg.id
}
output "private_security_group_id" {
  description = "The ID of the private security group"
  value = aws_security_group.private_sg.id
}
, Now
,

providers.tf
, Now
,

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
}
, Now
,

variables.tf
, Now
,

variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  type = string
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  description = "The CIDR block for public subnet"
  type = string
  default = "10.0.1.0/24"
}
variable "private_subnet_cidr" {
  description = "The CIDR block for private subnet"
  type = string
  default = "10.0.2.0/24"
}
variable "region" {
  description = "The AWS region"
  type = string
  default = "eu-north-1"
}
variable "az" {
  description = "The availability zone"
  type = string
  default = "eu-north-1a"
}

#!/bin/bash

ssh-keygen -t rsa -f $HOME/.ssh/minecraft-tf -N ''
terraform apply -auto-approve
#!/bin/bash

terraform destroy -auto-approve
rm -r $HOME/.ssh/minecraft-tf*

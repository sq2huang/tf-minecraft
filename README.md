# Minecraft Server using EC2

Automatically create minecraft server with on AWS EC2

## Getting Started

1) Clone repository
2) In repository root, run `terraform init`
3) `bash terraform-apply.sh` to start server. IP address is output of script upon completion. May be 1-2 minute delay between script completion and being able to connect in minecraft
4) `bash terraform-destroy.sh` to remove server

You should not configure the resources on your aws account made with this script from the dashboard. All changes to provisioned resources should be done through terraform.

### Prerequisites

1) Configure AWS CLI following instructions here https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
2) Install terraform (0.12.26) https://www.terraform.io/downloads.html

# subnets-tf

**Info**
------
This Terraform module creates a range of subnets and associates them with a given route table.

**_Note:_** This module was originally pulled from https://github.com/sebolabs/subnets-tf and was extended by me to meet additional requirements.

**Usage Stand Alone**
------
```python
provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "some_vpc_name"{
  cidr_block = "10.1.0.0/16"
  tags {
    Name="some_vpc_name"
  }
}
module "subnets" {
  source = "<path to>/modules/subnets-tf"

  project     = "lab"
  environment = "test"
  component   = "mgmt"
  name        = "nat"

  vpc_id             = "${aws_vpc.scos_cicd_vpc.id}"
  availability_zones = ["${data.aws_availability_zones.available.names}"]
  cidrs              = [
    "10.1.0.48/28",
    "10.1.0.64/28",
  ]
  map_public_ip_on_launch = false
  route_tables            = ["rtb-XXXXXXX"]
}
```

**Usage from another module**
------

**_Note:_** Assumes all `${var.*}` variables are defined

```python
module "subnets" {
  source = "<path to>/modules/subnets-tf"
  project     = "${var.project}"
  environment = "${var.environment}"
  component   = "${var.component}"
  name        = "${var.name}"

  vpc_id                  = "${var.vpc_id}"
  availability_zones      = ["${var.availability_zones}"]
  cidrs                   = ["${var.subnets_cidrs}"]
  map_public_ip_on_launch = "${var.subnets_map_public_ip_on_launch}"
  route_tables            = ["${var.subnets_route_tables}"]

  default_tags = "${var.default_tags}"
}
```
**Terraform compatibility**
------
TF versions tested: 0.9.11

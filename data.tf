data "aws_vpc" "dev_vpc" {
  filter {
    name = "tag:Name"
    values = ["dev-env-default_vpc"]
  }
}

data "aws_subnet" "private_1" {
  vpc_id = data.aws_vpc.dev_vpc.id
  filter {
    name = "tag:Name"
    values = ["private-1"]
  }
}
data "aws_subnet" "private_2" {
  vpc_id = data.aws_vpc.dev_vpc.id
  filter {
    name = "tag:Name"
    values = ["private-2"]
  }
}
data "aws_subnet" "private_3" {
  vpc_id = data.aws_vpc.dev_vpc.id
  filter {
    name = "tag:Name"
    values = ["private-3"]
  }
}
data "aws_subnet" "public_1" {
  vpc_id = data.aws_vpc.dev_vpc.id
  filter {
    name = "tag:Name"
    values = ["public-1"]
  }
}
data "aws_subnet" "public_2" {
  vpc_id = data.aws_vpc.dev_vpc.id
  filter {
    name = "tag:Name"
    values = ["public-2"]
  }
}
data "aws_subnet" "public_3" {
  vpc_id = data.aws_vpc.dev_vpc.id
  filter {
    name = "tag:Name"
    values = ["public-3"]
  }
}
data "aws_acm_certificate" "amazon_issued" {
  domain      = "steverhoton.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

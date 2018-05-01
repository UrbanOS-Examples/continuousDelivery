provider "aws" {
//    access_key = "ABC123"
//    secret_key = "DEF456"
    region = "us-east-2"
}

resource "aws_instance" "web" {
    ami = "ami-1ecae776"
    instance_type = "t2.micro"
}

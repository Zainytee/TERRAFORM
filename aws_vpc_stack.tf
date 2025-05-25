resource "aws_vpc" "botafli-zainy" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  
  tags = {
    Name = "Botafli-Zainy"
  }
}



resource "aws_subnet" "botafli-zainy_public" {
  vpc_id     = aws_vpc.botafli-zainy.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Public_subnet"
  }
}




resource "aws_subnet" "botafli-zainy_private" {
  vpc_id     = aws_vpc.botafli-zainy.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Private_subnet"
  }
}


resource "aws_internet_gateway" "botafli-zainy-IGW" {
  vpc_id = aws_vpc.botafli-zainy.id

  tags = {
    Name = "IGW"
  }
}


resource "aws_route_table" "botafli-zainy-PRT" {
  vpc_id = aws_vpc.botafli-zainy.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.botafli-zainy-IGW.id
  }

  tags = {
    Name = "Route Table"
  }
}



resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.botafli-zainy_public.id
  route_table_id = aws_route_table.botafli-zainy-PRT.id
}



resource "aws_security_group" "bz_secure" {
  name        = "bz_secure"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.botafli-zainy.id

  tags = {
    Name = "Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bz_secure_ingress_ipv4" {
  security_group_id = aws_security_group.bz_secure.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "bz_secure_egress_ipv4" {
  security_group_id = aws_security_group.bz_secure.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name        = "${var.app_name}-igw"
    Environment = var.app_environment
  }

}

resource "aws_subnet" "db" {
  vpc_id            = aws_vpc.aws-vpc.id
  count             = length(var.db_subnets)
  cidr_block        = element(var.db_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-db-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.aws-vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-private-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-public-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_name}-routing-table-public"
    Environment = var.app_environment
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws-igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids     = aws_subnet.db.*.id

  tags = {
    Name        = "${var.app_name}-postgres-db-subnet-group"
    Environment = var.app_environment
  }
}

resource "aws_eip" "CustomEIP" {
  vpc      = true

  tags = {
    Name        = "${var.app_name}-eip"
    Environment = var.app_environment
  }
}

resource "aws_nat_gateway" "CustomNAT" {
  allocation_id = aws_eip.CustomEIP.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name        = "${var.app_name}-nat-gateway"
    Environment = var.app_environment
  }
}

resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.aws-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.CustomNAT.id
  }

  tags = {
    Name        = "${var.app_name}-routing-table-private"
    Environment = var.app_environment
  }
}

resource "aws_route_table_association" "PrivateSubnetRouteTableAssociation" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.PrivateRouteTable.id
}


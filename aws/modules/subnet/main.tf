resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = merge(
    var.additional_tags,
    { "Name" = "${var.name}-igw" },
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.private_subnets, count.index)
  vpc_id            = var.vpc_id

  tags = merge(
    var.additional_tags,
    {
      Name = format("${var.name}-private-subnet-%s", element(var.azs, count.index))
    }
  )
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  vpc_id = var.vpc_id

  tags = merge(
    var.additional_tags,
    {
      Name = format("${var.name}-private-rt-%s", element(var.azs, count.index))
    },
    var.eks_private_tag ? {
      "kubernetes.io/role/internal-elb" = "1"
    } : {},
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_subnet" "private_db" {
  count = length(var.private_subnets_db)

  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.private_subnets_db, count.index)
  vpc_id            = var.vpc_id

  tags = merge(
    var.additional_tags,
    {
      Name = format("${var.name}-private-db-subnet-%s", element(var.azs, count.index))
    }
  )
}

resource "aws_route_table" "private_db" {
  count = length(var.private_subnets_db)

  vpc_id = var.vpc_id

  tags = merge(
    var.additional_tags,
    {
      Name = format("${var.name}-private-rt-db-%s", element(var.azs, count.index))
    }
  )
}

resource "aws_route_table_association" "private_db" {
  count = length(var.private_subnets_db)

  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_db[count.index].id
}

resource "aws_nat_gateway" "nat" {
  count = length(var.public_subnets)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.additional_tags,
    {
      Name = format("${var.name}-nat-%s", element(var.azs, count.index))
    }
  )
}

resource "aws_eip" "nat" {
  count = length(var.private_subnets)

  tags = merge(
    var.additional_tags,
    {
      Name = format("${var.name}-eip-%s", element(var.azs, count.index))
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  availability_zone       = element(var.azs, count.index)
  cidr_block              = element(var.public_subnets, count.index)
  ipv6_cidr_block         = element(var.public_subnets_ipv6, count.index)
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = true

  tags = merge(
    var.additional_tags,
    {
      Name = format("${var.name}-public-subnet-%s", element(var.azs, count.index))
    },
    var.eks_public_tag ? {
      "kubernetes.io/role/elb" = "1"
    } : {},
  )
}

resource "aws_route_table" "public" {
  count = length(var.public_subnets)

  vpc_id = var.vpc_id

  tags = merge(
    var.additional_tags,
    {
      Name = format("${var.name}-public-rt-%s", element(var.azs, count.index))
    }
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnets)

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway" {
  count = length(var.private_subnets)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

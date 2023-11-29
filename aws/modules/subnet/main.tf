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
    }
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(
    aws_route_table.private[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  availability_zone       = element(var.azs, count.index)
  cidr_block              = element(var.public_subnets, count.index)
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = true

  tags = merge(
    var.additional_tags,
    {
      Name = format("${var.name}-public-subnet-%s", element(var.azs, count.index))
    }
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

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}

resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnets)

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_security_group" "redis-sg" {
  name        = "devops-redis-sg"
  description = "Port 6379 traffic"
  vpc_id      = "${data.aws_vpc.selected.id}"
  tags        = "${module.resource_tag.tags}"
}

resource "aws_security_group_rule" "ingress" {
  type                     = "ingress"
  from_port            = 6379
  to_port                 = 6379
  protocol               = "tcp"
  source_security_group_id = "${data.aws_security_group.devops-sg.id}"
  security_group_id        = "${aws_security_group.devops-redis-sg.id}"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.devops-redis-sg.id}"
}

#Custom Redis module to add additional variables
module "redis_cluster" {
  source                 = "xyz.com-ecs-redis.git?ref=develop"
  app_name               = "devops-redis"
  vpc                    = "${var.vpc}"
  security_group         = "${aws_security_group.devops-redis-sg.id}"
}

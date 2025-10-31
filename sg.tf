resource "aws_security_group" "worker_sg"{
    name = "worker_sg"
    description = "SG rules for workers"
    vpc_id = local.vpc_id
}
resource "aws_security_group_rule" "rule1" {
    security_group_id = aws_security_group.worker_sg.id
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["172.31.0.0/16","10.0.0.0/8"]
    description = "Allow communication over 443 from within the vpc(172 cidr) and cluster services(10 cidr)"
  
}
resource "aws_security_group_rule" "rule2" {
    security_group_id = aws_security_group.worker_sg.id
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [local.myip]
    description = "Allow communication over 443 from myip"
  
}
resource "aws_security_group_rule" "rule3" {
    security_group_id = aws_security_group.worker_sg.id
    type = "ingress"
    from_port = 30008
    to_port = 30008
    protocol = "tcp"
    cidr_blocks = [local.myip]
    description = "Allow communication over nodeport from myip"
  
}
resource "aws_security_group_rule" "rule3" {
    security_group_id = aws_security_group.worker_sg.id
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [local.myip]
    description = "Allow outbound communication to anywhere"
  
}
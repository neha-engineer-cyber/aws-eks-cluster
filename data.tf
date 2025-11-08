data "aws_subnets" "subnet_ids"{
    filter{
        name = "vpc-id"
        values=[local.vpc_id]
    }
    
}
data aws_subnets subnet_ids{
    filter{
        name = "vpcid"
        values=[local.vpc_id]
    }
    
}
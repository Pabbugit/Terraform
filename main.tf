module "firstvpc" {

  source = "./modules/networking"
  
}

module "myec2"{
    source = "./modules/ec2"
    subnet_id = module.firstvpc.pub_sub_ids[0]
}
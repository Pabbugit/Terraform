locals {
  pub_sub_ids = aws_subnet.public.*.id
}

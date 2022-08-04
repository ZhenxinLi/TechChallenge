// gathering the ip address of the subnet we are deploying into 
resource "local_file" "env_file" {
    content = <<-DOC
    WEB=${aws_instance.web.public_ip}
    DOC
    filename = "../ansible/.env"
}
//gathering the outputs for future conf.toml configuration
output "db_endpoint" {
  value = aws_db_instance.data.endpoint
}

output "db_user" {
  value = aws_db_instance.data.username
}

output "db_password" {
  value     = aws_db_instance.data.password
  sensitive = true
}

output "lb_endpoint" {
  value = aws_lb.public_lb.dns_name
}


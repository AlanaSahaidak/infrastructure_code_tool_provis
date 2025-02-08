output "elasticsearch_public_ip" {
  value = aws_instance.terraform_elasticsearch.public_ip
}
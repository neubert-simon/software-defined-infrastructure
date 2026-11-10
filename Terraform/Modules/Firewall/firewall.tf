locals {
  firewall_rules = {
    ssh = {
      description = "Allow SSH"
      direction   = "in"
      protocol    = "tcp"
      port        = "22"
      source_ips  = ["0.0.0.0/0", "::/0"]
    }

    icmp = {
      description = "Allow ICMP"
      direction = "in"
      protocol  = "icmp"
      source_ips = ["0.0.0.0/0", "::/0"]
    }

    http = {
      description = "Allow HTTP"
      direction   = "in"
      protocol    = "tcp"
      port        = "80"
      source_ips  = ["0.0.0.0/0", "::/0"]
    }

    https = {
      description = "Allow HTTPS"
      direction   = "in"
      protocol    = "tcp"
      port        = "443"
      source_ips  = ["0.0.0.0/0", "::/0"]
    }
  }
}

output "firewall_rules" {
  description = "Reusable firewall rule definitions"
  value       = local.firewall_rules
}
module "firewall" {
  source = "../Modules/Firewall"
}

resource "hcloud_firewall" "nginx" {
  name = "nginx"

  dynamic "rule" {
    for_each = {
      for name in ["ssh", "icmp", "http"] : name => module.firewall.firewall_rules[name]
    }
    content {
      description = rule.value.description
      direction   = rule.value.direction
      protocol    = rule.value.protocol
      port        = rule.value.protocol == "icmp" ? null : rule.value.port
      source_ips  = rule.value.source_ips
    }
  }
}
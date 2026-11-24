resource "hcloud_firewall" "firewall" {
  name = "dynamic_firewall"

  dynamic "rule" {
    for_each = {
      for name in var.rules : name => local.firewall_rules[name]
    }
    content {
      description = rule.value.description
      direction   = rule.value.direction
      protocol    = rule.value.protocol
      port        = rule.value.port == "icmp" ? null : rule.value.port
      source_ips  = rule.value.source_ips
    }
  }
}
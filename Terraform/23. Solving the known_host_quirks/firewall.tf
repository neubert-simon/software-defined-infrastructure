module "firewall" { source = "../Modules/Firewall" }

resource "hcloud_firewall" "SSH" {
  name = "ssh"

  dynamic "rule" {
    for_each = {
      for name in ["ssh"] : name => module.firewall.firewall_rules[name]
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
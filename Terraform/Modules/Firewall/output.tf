output "firewall_rules" {
  description = "Reusable firewall rule definitions"
  value       = local.firewall_rules
}

output "firewallID" {
  description = "Firewall ID"
  type        = string
  value       = hcloud_firewall.firewall.id
}
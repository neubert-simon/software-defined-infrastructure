module "firewall" {
  source = "../Modules/Firewall"
  rules = ["ssh", "icmp", "http"]
}
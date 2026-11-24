module "firewall" {
  source = "../Modules/Firewall"
  rules = ["ssh"]
}
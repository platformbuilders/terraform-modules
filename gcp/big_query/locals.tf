locals {
  tier_name       = format("%s_%s", var.tier, var.name)
  asset_tier_name = format("%s-%s", var.tier, var.name)
  zone_tier_name  = format("dataplex-%s-%s", var.tier, var.name)
}

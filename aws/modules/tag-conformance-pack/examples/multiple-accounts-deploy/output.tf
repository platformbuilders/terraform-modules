output "applications_string_output" {
  value = module.ConformancePack.all_application_tags
}

output "application_string_length" {
  value = "Deve ser menor do que 1024 -> string length: ${length(module.ConformancePack.all_application_tags)}"
}


output "domains_string_output" {
  value = module.ConformancePack.all_domain_tags
}

output "domain_string_length" {
  value = "Deve ser menor do que 1024 -> string length: ${length(module.ConformancePack.all_domain_tags)}"
}

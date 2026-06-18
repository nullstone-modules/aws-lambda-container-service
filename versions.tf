terraform {
  required_providers {
    ns = {
      source  = "nullstone-io/ns"
      version = "~> 0.11.0"
    }
    dockerless = {
      source = "nullstone-io/dockerless"
    }
  }
}

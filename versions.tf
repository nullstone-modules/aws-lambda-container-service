terraform {
  required_providers {
    ns = {
      source  = "nullstone-io/ns"
      version = "~> 0.13.0"
    }
    dockerless = {
      source = "nullstone-io/dockerless"
    }
  }
}

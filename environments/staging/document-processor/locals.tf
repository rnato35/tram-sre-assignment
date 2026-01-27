locals {
  tags = merge(
    {
      ManagedBy = "terraform"
    },
    var.tags
  )
}

module "ecr_client" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"

  repository_name                 = "web3/client"
  repository_type                 = "private"
  repository_image_scan_on_push   = false
  repository_image_tag_mutability = "MUTABLE"
  repository_force_delete         = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

}

module "ecr_smart_contract" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"

  repository_name                 = "web3/smartcontract"
  repository_type                 = "private"
  repository_image_scan_on_push   = false
  repository_image_tag_mutability = "MUTABLE"
  repository_force_delete         = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

}
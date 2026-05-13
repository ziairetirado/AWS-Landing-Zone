resource "random_id" "suffix" {
  byte_length = 4
}



module "organization" {
  source = "./modules/organization"

  providers = {
    aws = aws
  }
}

#####Organization ^

module "accounts" {
  source = "./modules/accounts"

  providers = {
    aws = aws
  }

  account_name          = "landing-zone"
  management_account_id = module.organization.management_account_id
}

### Kms
resource "aws_kms_key" "logging" {
  provider            = aws
  description         = "KMS key for logging"
  enable_key_rotation = true
}

### S3
module "s3_logging" {
  source = "./modules/s3_logging"

  providers = {
    aws = aws
  }

  bucket_suffix = random_id.suffix.hex
  kms_key_arn   = aws_kms_key.logging.arn
}

## CloudTrail
module "cloudtrail" {
  source = "./modules/cloudtrail"

  providers = {
    aws = aws
  }

  cloudtrail_bucket_id  = module.s3_logging.cloudtrail_bucket_id
  cloudtrail_bucket_arn = module.s3_logging.cloudtrail_bucket_arn
}



#### Guardrails
module "guardrails" {
  source = "./modules/guardrails"

  providers = {
    aws = aws
  }

  organization_root_id = module.organization.root_id
}



### GuardDuty Security 
module "guardduty" {
  source = "./modules/guardduty"

  providers = {
    aws = aws
  }

  security_account_id = module.accounts.security_account_id
}


module "iam_security" {
  source = "./modules/iam-security"
}
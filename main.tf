############################################
# 1. CLOUDTRAIL (ORG-WIDE LOGGING)
############################################

resource "aws_cloudtrail" "org_trail" {
  name                          = "org-trail"
  s3_bucket_name               = var.cloudtrail_bucket_id
  is_organization_trail        = true
  include_global_service_events = true
  enable_logging               = true
}


############################################
# 2. IAM POLICY DOCUMENT (FOR S3 ACCESS)
#    - Defines what CloudTrail is allowed to do
############################################

data "aws_iam_policy_document" "cloudtrail_policy" {

  statement {
    sid     = "AllowCloudTrailGetBucketAcl"
    effect  = "Allow"

    actions = ["s3:GetBucketAcl"]

    resources = [var.cloudtrail_bucket_arn]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid     = "AllowCloudTrailPutObject"
    effect  = "Allow"

    actions = ["s3:PutObject"]

    resources = ["${var.cloudtrail_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}


############################################
# 3. S3 BUCKET POLICY ATTACHMENT
#    - Applies the IAM policy to the bucket
############################################

resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = var.cloudtrail_bucket_id
  policy = data.aws_iam_policy_document.cloudtrail_policy.json
}
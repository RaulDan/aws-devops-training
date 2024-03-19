resource "aws_ecr_repository" "online-shop-repo" {
  name                 = "online-shop-image-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "cicd_pipeline" {
  name = "OnlineShopCiCdPipeline"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.github_actions.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringLike" : {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" : ["repo:RaulDan/aws-devops-training*"]
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy" "gha_oidc_terraform_permissions" {
  name = "gha_oidc_terraform_permissions"
  role = aws_iam_role.cicd_pipeline.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage"
        ],
        "Resource": "*"
      }
    ]
  })
}

#resource "aws_iam_role_policy_attachment" "attach_ecr_policy" {
#  policy_arn = aws_iam_policy.ecr_policy.arn
#  role       = aws_iam_role.cicd_pipeline.name
#}

#resource "aws_iam_openid_connect_provider" "github-oidc" {
#  client_id_list  = ["sts.amazonaws.com.cn"]
#  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
#  url             = "https://token.actions.githubusercontent.com"
#}

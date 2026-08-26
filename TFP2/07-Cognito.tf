# Creates authentiation system 
resource "aws_cognito_user_pool" "tfp2_user_pool" {
  name = "tfp2-user-pool"

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

# What frontend uses to sign in 
resource "aws_cognito_user_pool_client" "tfp2_user_pool_client" {
  name         = "tfp2-user-pool-client"
  user_pool_id = aws_cognito_user_pool.tfp2_user_pool.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}

# Cognito domain
resource "aws_cognito_user_pool_domain" "tfp2_domain" {
  domain       = "tfp2-auth"
  user_pool_id = aws_cognito_user_pool.tfp2_user_pool.id
}

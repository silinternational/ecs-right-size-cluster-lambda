
/*
 * Create IAM user for Serverless framework to use to deploy the lambda function
 */
module "serverless-user" {
  source  = "silinternational/serverless-user/aws"
  version = "~> 0.4"

  app_name   = "ecs-right-size"
}

terraform {
  cloud {
    organization = "gtis"

    workspaces {
      name = "ecs-right-size-cluster-lambda"
    }
  }
}

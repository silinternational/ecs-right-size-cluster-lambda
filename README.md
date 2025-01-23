# Archived

This tool is no longer being maintained.

# ecs-right-size-cluster-lambda
Auto-scaling for ECS clusters in AWS based on built in CloudWatch alarms/events really isn't sufficent nor does it work
very well. As a result we created this Lambda script to periodically check given ECS clusters and scale them appropriately.

## The Problem
The problem is CloudWatch events available for use with normal auto-scaling are based on CPU/Memory utilization or 
reservation and unfortunately reservation means how much your asking for based on the tasks that have been placed and 
are running on the given cluster. However if you create a new service or increase the desired count for an existing 
service and do not have enough EC2 capacity to handle the load the new tasks are not counted against the reservation 
and therefore a CloudWatch event is not triggered to auto-scale. 

Sure you could use Fargate if budget isn't a concern (Fargate is WAY more expensive than traditional EC2 instances).

## The Solution
This Lambda script takes a given ECS cluster name, then determines what auto-scaling group is used to manage the EC2 
instances and the instance type in use (ex: t2.micro). It then looks through all ECS Services with a desired count > 0 
and calculates how much capacity is really needed regardless of how many of the tasks have actually been placed and 
running. It also adds enough capcity to launch one more instance of the "largest" service for either memory or CPU 
needed just to make sure enough capacity is present for rolling releases. Optionally it can be told not to set the 
ASG count less than the largest "desired count" amount. That way if you want three tasks running on three different 
instances, even if they could all fit on a single instance it will not set the ASG count below 3. 

## Usage
The `deploy-lambdas.sh` script can be used to build the Go binary and deploy the lambda function to AWS. If you don't 
have NPM and Go installed locally you can use the Docker image with Docker Compose to build and deploy from a container 
so you do not have to install all dependencies locally. Here are instructions for deploying with Docker:

1. Copy `.env.example` to `.env` and update with appropriate values
2. Run `docker-compose run app ./deploy-lambdas.sh`

## IAM Permissions for running Serverless
In order for Serverless to do its work you'll need a user with the following IAM permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:UpdateAutoScalingGroup",
        "cloudformation:*",
        "ec2:DescribeInstances",
        "ecs:DescribeContainerInstances",
        "ecs:DescribeServices",
        "ecs:DescribeTaskDefinition",
        "ecs:ListContainerInstances",
        "ecs:ListServices",
        "events:*",
        "iam:CreateRole",
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy",
        "iam:PassRole",
        "iam:DetachRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:GetRole",
        "iam:DeleteRole",
        "iam:CreatePolicy",
        "lambda:*",
        "logs:*",
        "s3:*"
      ],
      "Resource": [
          "*"
      ]
    }
  ]
}
```

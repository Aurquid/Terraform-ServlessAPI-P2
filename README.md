# Terraform-ServerlessAPI
# Overview



# 📘 Table of Contents
* [Overview](#overview)
* [Architecture Diagram](#architecture-diagram)
* [Architecture Summary](#architecture-summary)
* [Services Used](#services-used)
* [Folder Structure](#folder-structure)
* [Deployment](#deployment)
* [IAM Least Privilege](#iam-least-privilege)
* [Tradeoff Analysis](#tradeoff-analysis)
* [Cost Breakdown](#cost-breakdown)
* [Cost Analysis](#cost-analysis)
* [Cost & Security Considerations](#cost--security-considerations)
* [Architecture Tradeoffs](#architecture-tradeoffs)
* [FinOps Recommendations](#finops-recommendations)
* [Future Improvements](#future-improvements)
* [Failure Scenario & Recovery Playbook](#failure-scenario--recovery-playbook)
* [Lessons Learned](#lessons-learned)
* [Screenshots](#screenshots)


# Architecture Diagram


# Architecture Summary 
* API Gateway (entry point)

* Lambda (compute)

* DynamoDB (data layer)

* CloudWatch (monitoring)

* IAM (permissions)


# Services Used

  
##  Folder Structure
     

  # Deployment
* terraform init
* terraform plan
* terraform apply

# IAM Least Privilege
This section describes how permissions are restricted within the AWS account to follow the principle of least privilege.

* **Lambda Execution Role**: The `tfp2-lambda-exec-role` grants only the permissions required for CloudWatch logging and DynamoDB access.  
 * **Policy Attachments**:  
   `AWSLambdaBasicExecutionRole` enables log creation and event publishing to CloudWatch.  
   `AmazonDynamoDBFullAccess` allows read/write operations on DynamoDB tables used by the API.  
* **Cognito Context**: Cognito manages authentication for external users, while IAM controls what AWS resources those authenticated identities can access. Even though all resources are under one account, Cognito users receive temporary credentials mapped to IAM roles with limited permissions.  
* **Security Principle**: No wildcard actions are used; each policy specifies exact resources and actions it needs. This minimizes exposure and ensures Lambda and Cognito operate with only the privileges they need.

#  Tradeoff Analysis
This section explains the architectural decisions and their tradeoffs.





# Cost Breakdown 
| Component | Cost | Notes |
|------------|------|-------|
| Lambda | ~$0.20 per 1M requests | Pay per invocation |
| API Gateway | ~$3.50 per 1M requests | Charged per call |
| DynamoDB | ~$1.25 per GB storage | Scales automatically |
| CloudWatch Logs | ~$0.50 per GB ingested | Minimal for small workloads |
| Data Transfer | variable | Depends on traffic volume |

# Cost Analysis
This section explains how the system costs incur under different usage levels and identifies cost risks and optimization opportunities.

### Usage-Based Cost Behavior
* **Lambda** costs remain low until it runs long functions or receives a large amount of requests.
* **API Gateway** charges are made per API call, which can be the primary cost driver under heavy usage.
* **DynamoDB On-Demand** scales with read/write operations, eliminating capacity planning but can increase costs based on API usage.
* **CloudWatch Logs** incur  costs for ingestion and storage; retention is set to 14 days to avoid long-term storage.

### Cost Risks
* High-volume logging can increase CloudWatch ingestion cost.
* DynamoDB may cause high costs in read/write usage.
* API Gateway costs are based on traffic.

### Optimization Levers
* Lower CloudWatch retention or filter logs to reduce ingestion.
* Use DynamoDB GSIs to reduce expensive queries.
# Cost & Security Considerations
# Architecture Tradeoffs
# FinOps Recommendations
# Future Improvements
# Failure Scenario & Recovery Playbook
### Scenario : 
### Root Cause: 
###  Recovery Steps:
### Prevention:
 
### Scenario:  
### Root Cause: 
### Recovery Steps:  

### Prevention:

# Lessons Learned

 
 
# Screenshots
  

















 

 

 
 

 
 


 

  

 
 
 
 


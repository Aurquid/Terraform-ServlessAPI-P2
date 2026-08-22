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
   `AWSLambdaBasicExecutionRole` allows log creation and event publishing to CloudWatch.  
   `AmazonDynamoDBFullAccess` allows read/write operations on DynamoDB tables used by the API.  
* **Cognito Context**: Cognito manages authentication for external users, while IAM controls what AWS resources those authenticated identities can access. Even though all resources are under one account, Cognito users receive temporary credentials connected to IAM roles with limited permissions.  
* **Security Principle**: Lambda only has access to logging and DynamoDB access. There is only access allowed only to what the API needs under least privilege. 

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
* **CloudWatch** log retention is kept at 14 days to keep storage costs low while providing sufficient information for debugging and audit needs.
* **Cognito authentication** includes small expenses but prevents unauthorized API calls to reduce API costs
*  **AWS WAF** protects the CloudFront layer from common web exploits with little impact on costs

  ### Cost Decisions That Affect Security 
* Avoiding advanced monitoring can lower costs but increases security exposure
* Keeping log retention short can limit the availability of log information during incidents

# Architecture Tradeoffs
* **Lambda + API Gateway** removes operational overhead but limit control on networking, connections, and long-running jobs
* **Serverless architecture** keeps costs low and scales automatically but makes incident analysis harder than with an EC2 or container environment
* **CloudFront + WAF** combination protects against common web attacks but requires more configuration than an API Gateway by itself
* **DynamoDB** scales automatically without provisioning but sustained high traffic can be more expensive than provisioned capacity
  
# FinOps Recommendations
These recommendations focus on improving costs and optimization 
* Utilize **AWS Cost Explorer and Budgets** to track Lambda, API Gateway, and DynamoDB usage and turn on alerts to track high costs
* Add **CloudWatch dashboards** to keep track of request count, latency, and error alerts to identify issues
* Use **Lambda Power Tuning** to identify the optimal memory configuration that minimizes cost with lowering quality performance
* Research **API Gateway usage plans** and turn on API throttling to minimize costs during high volume requests
* **Tag all resources** to keep track of cost allocation and and accuracy
* **AWS Trusted Advisor and Compute Optimizer** to identify underutilized resources or misconfigured resources
 # Future Suggestions for Improvements
 * Add **automated backups and recovery** for DynamoDB to include resiliency 
 * Add **multi-region replication**  for high availability and disaster recovery
 * Add **CI/CD automation** with AWS CodePipeline for easier deployments and reduce manual
   updates
* Include **Terraform modules** for reusability in resources in order to use in other projects
* Use **AWS Shield Advance** for stronger DDos protection
# Failure Scenario & Recovery PlaybookC
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
  

















 

 

 
 

 
 


 

  

 
 
 
 


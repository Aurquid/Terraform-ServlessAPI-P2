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
* API Gateway for entry point for client requests

* Lambda for serverless compute for backend logic

* DynamoDB NoSQL database for storage

* CloudFront for content delivery and caching8
  
* WAF for protecting CloudFront

* Cognito for user authentication and authorization

* CloudWatch to record logging, metrics, and alarms for monitoring

* IAM controls for least privilege for AWS resources 


# Services Used
* AWS Lambda
* API Gateway
* DynamoDB
* CloudWatch
* Cognito
* CloudFront
* AWS WAF
* IAM
  
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
| CloudWatch Logs | ~$0.50 per GB ingested +$.03 per gb of logs stored| Minimal for small workloads |
| CloudFront|$0.085 per gb| regional rates vary|
|Cognito| Free for 10k MAU| Includes authentication and token issuance|
|WAF| $5 per Web ACL + $1 per rule group + $0.60 per M requests| Minimal due to workload|
| Data Transfer | variable | Depends on traffic volume |

# Cost Analysis
This section explains how the system costs incur under different usage levels and identifies cost risks and optimization opportunities.

### Usage-Based Cost Behavior
* **Lambda** costs remain low until it runs long functions or receives a large amount of requests.
* **API Gateway** charges are made per API call, which can be the primary cost driver under heavy usage.
* **DynamoDB On-Demand** scales with read/write operations, eliminating capacity planning but can increase costs based on API usage.
* **CloudWatch Logs** incur  costs for ingestion and storage; retention is set to 14 days to avoid long-term storage.\
* **CloudFront** caching reduces repeated requests and keep costs minimal for workload
* **Cognito** costs depend on monthly users so its negligible for this project
* **WAF** costs remain low due to low volume traffic

### Cost Risks
* High-volume logging can increase CloudWatch ingestion cost
* DynamoDB may cause high costs in read/write usage
* API Gateway costs are based on traffic
* Large data transfer volume can increase costs can raise CDN fees for CloudFront
* Costs rise for Cognito if user base increases past free tier
* WAF costs increase for every additional managed rule group or high requests based on traffic

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
* Use **Lambda Power Tuning** to identify the optimal memory configuration that minimizes cost without lowering performance
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
# Failure Scenario & Recovery Playbook
### Scenario : 
Lambda Function Failure
### Root Cause: 
Lambda function is missing environment variables or IAM permissions
###  Recovery Steps:
1. Check CloudWatch logs for errors and stack traces
2. Verify IAM permissions for DynamoDB read/write access
3. Redeploy Lambda with correct environment variables or updated policy
4. Run test events to validate changes
### Prevention:
 * Add CI/CD validation for environment variables and IAM permissions before deployment
### Scenario:  
DynamoDB denied access
### Root Cause: 
Lambda function fails to read or write data due to lack of DynamoDB permissions
### Recovery Steps:  
1. Check CloudWatch logs for denied access errors
2. Review Lambda execution role policy for missing permissions
3. Update IAM policy and redeploy Lambda functions
4. Run test events again to verify permissions

### Prevention:
* Add CI/CD with IAM policy validation

# Lessons Learned
* Validating IAM permissions early prevents Lambda errors and unnecessary debugging
* CloudWatch logs and stack traces are important to identify root causes early
* Least-privilege design is important for security and operational stability
* Testing terraform blocks after changes helps ensure resource dependencies and help identify errors early
* Documenting recovery steps and architecture decisions improves future troubleshooting 
 
# Screenshots
<img width="1086" height="407" alt="Screenshot 2026-08-25 144725" src="https://github.com/user-attachments/assets/8380e17d-2a87-440c-96e5-a3c3eb17a421" />
<img width="727" height="442" alt="Screenshot 2026-08-25 144757" src="https://github.com/user-attachments/assets/d0c772df-8c27-4f71-b138-7cd3e90410ec" />
<img width="1093" height="543" alt="Screenshot 2026-08-25 144841" src="https://github.com/user-attachments/assets/5e6ab863-9905-4a34-8a31-a27a2d82a467" />
<img width="1070" height="487" alt="Screenshot 2026-08-25 151137" src="https://github.com/user-attachments/assets/803c4ee6-2c3c-4f46-8b58-a9b72661f7e1" />
<img width="857" height="433" alt="Screenshot 2026-08-25 155642" src="https://github.com/user-attachments/assets/b8cb6b89-15d7-4ccc-bacc-cbee92a32d57" />
<img width="1112" height="496" alt="Screenshot 2026-08-25 160253" src="https://github.com/user-attachments/assets/5a139bf4-273e-4211-b6c4-5bb18f34f544" />
<img width="1090" height="535" alt="Screenshot 2026-08-25 160326" src="https://github.com/user-attachments/assets/30ef7f16-450e-4726-bf26-892751978596" />
<img width="1096" height="514" alt="Screenshot 2026-08-25 160309" src="https://github.com/user-attachments/assets/97efc89f-7430-4743-9c5a-02edff55daa5" />
<img width="1092" height="515" alt="Screenshot 2026-08-25 160622" src="https://github.com/user-attachments/assets/43f8d127-a6f2-41df-8f7a-a4c115e6e9e8" />
<img width="867" height="415" alt="Screenshot 2026-08-25 161210" src="https://github.com/user-attachments/assets/fe9c4b13-32e1-4358-827d-389c9f703fc3" />
<img width="1115" height="522" alt="Screenshot 2026-08-25 162203" src="https://github.com/user-attachments/assets/954bbde5-0378-48f1-90ee-fa0504fbec3c" />
<img width="1096" height="482" alt="Screenshot 2026-08-25 162428" src="https://github.com/user-attachments/assets/459c2fbb-e22a-4a12-80d8-1e3c02358c82" />
<img width="1037" height="467" alt="Screenshot 2026-08-25 163254" src="https://github.com/user-attachments/assets/3fcd6d2f-fedb-44ab-ab7c-742e253d88ce" />
<img width="1067" height="491" alt="Screenshot 2026-08-25 163331" src="https://github.com/user-attachments/assets/9fccc8ce-8619-4e25-b5c7-8c3285d19f85" />
<img width="867" height="464" alt="Screenshot 2026-08-25 163655" src="https://github.com/user-attachments/assets/ecdb56b0-bb27-4c20-b6bf-46218e6598f6" />

















 

 

 
 

 
 


 

  

 
 
 
 


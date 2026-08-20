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

# Cost & Security Considerations
# Architecture Tradeoffs
# FinOps Recommendations
# Future Improvements
# Failure Scenario and Recovery Playbook
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
  

















 

 

 
 

 
 


 

  

 
 
 
 


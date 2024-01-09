
<!--- ## Google-Cloud-Centralized-logging) -->
## Automation Name: 	Google-Cloud-Centralized-logging

##### Author
|**Name**             | **Email**                         |
|---------------------| --------------------------------- | 
|Sirshendu Mazumdar   | sirshendum@gmail.com     |


##### Table of Contents

---

## Table of Content

1. [Introduction](#introduction)<br/>
2. [Prerequisites](#prerequisites)<br/>
3. [Inputs Variables](#inputsv)<br/>
4. [Operational-Description](#operational-description)<br/>
	1. [Deployment Procedure](#deployment-procedure)<br/>
	2. [Management View](#management-view)<br/>
	3. [Cleanup View](#cleanup-view)<br/>
5. [Testing](#test-case)<br/>
6. [Known Problems and Limitations](#known-problems-and-limitations)<br/>

---

<a name="introduction">

## 1. Introduction

Cloud Logging is a fully managed service that allows you to store, search, analyse, monitor, and alert on logging data and events from Google Cloud. Logging includes storage for logs through log buckets, a user interface called the Logs Explorer, and an API to manage logs programmatically. Logging lets you read and write log entries, query your logs, and control how you route and use your logs.

Google Cloud Centralized logging enables you to create systems of to transfer all spoke folders & projects logs to centralized Logging project & Log bucket. It also enables to implement customized archive policy of logs to Cloud Storage based on customer need. 

Below mentioned services component of Cloud Logging service will be used as input parameter of IAC automation farmwork, customer will have option to choose this inputs parameter as per there business requirement.

Cloud Logging Google Documentation: https://cloud.google.com/logging/docs/

<a name="prerequisites">

## 2. Prerequisites

1.  Access to Google Cloud

2.  Hub/Spoke Landing zone / Application should exist

3.  Ensure SA creation  and  appropriate IAM role assignment.

4.  Following Google Cloud APIs should be enabled
    1.  storage.googleapis.com
    2.  iam.googleapis.com
    3.  cloudresourcemanager.googleapis.com
    4.  logging.googleapis.com

5.  Log Bucket must be available for successful execution of the this automation. Log   Bucket can be created manually using bellow inputs,
    1. ```Login``` to Google Cloud Console.
    2. Select the ```Logging project``` from project drop down menu. Logging project must be hosted under Hub folder to holds logs of all Hub & Spoke projects.
    3. Select ```Log Storage``` and click on ```Create Log Bucket```, Following fields need to updated Name ( same value to be updated on ```var.log_bucket_id``` ), Description (Add identifiable text), Log Bucket Region (Global) , Retention period ( 365 days)

       
<a name="inputsv"> 

## 3. Inputs Variables
| Sr. No. |  Name       	| Description      | Type  | Default | Required |
|---------|-----------------|------------------|-------|---------|----------|
1 | hub_project_id  | The hub project ID to host common resourcs | string | na | yes
2 | tf_service_account | Default Service account | string | na | yes
3 | hub_logging_project_id | The project ID for centralized logging project | string | na | yes
4 | region | Default region Name| string  | na | yes
5 | spoke_folder_id| The Spoke Folder ID for centralized logging | string  | na | yes
6 | hub_folder_id| The Hub Folder ID for centralized logging | string  | na | yes
7 | logging_bucket_location | The location of the logging bucket | string| global | yes
8 | log_bucket_id | The ID of the logging bucket | string  | na | yes
9 | bucket_cloud_storage_name | The ID of the cloud storage bucket | string  | na | yes
10 | retention_policy_is_locked | Retention Policy for bucket locked permanently restrict | string  | false | yes
11 | retention_policy_retention_period| The period of time, in seconds, that objects in the bucket must be retained  | string  | na | yes

<a name="operational-description"> 

## 4. Operational Description

This section describes steps/ procedure i.e. how to deploy the Centralized Logging resource provisioning module automation. This section contains multiple subsections as noted below.

*   Deployment Procedure
*   Management View
*   Clean up

<a name="deployment-procedure">
	
#### 4.1 Deployment Procedure

The code in this repository is structured as follows:

- The environments/ folder contains subfolders main has main terraform configuration file like main.tf,variable.tf,terraform.tfvars

- The cloudbuild.yaml file is a build configuration file that contains instructions for Cloud Build, such as how to perform tasks based on a set of steps. This file specifies a conditional execution depending on the branch Cloud Build is fetching the code from, for example:

- For main branches, the following steps are executed:
	

```plaintext
  terraform init
  terraform plan
  terraform apply
``` 

- To ensure that the changes being proposed are appropriate for every environment, terraform init and terraform plan are run for all environments subfolders.
	
#### Deployment Procedure Steps :

1. Clone the repository: ```https://github.com/sirshendum/Google-Cloud-Centralized-Logging.git```
    - Login to terminal (Be it Cloud Shell or Developer Laptop). Issue the following command: ```git clone https://github.com/sirshendum/Google-Cloud-Centralized-Logging.git```

   Connecting GitHub using HTTPS :  https://docs.github.com/en/pages/getting-started-with-github-pages/securing-your-github-pages-site-with-https 

2. In the ```terraform.tfvars``` file  variables values have been supplied and should be customized:
     ```
       Service Account used for Centralized Logging resource creation on Hub Project :
        tf_service_account             = "sa-tf-cental-logging@<hub-project-id>.iam.gserviceaccount.com"

        Hub Project name will host the common resources :
        hub_project_id                = "<name of hub project>"
          
        The project ID for centralized logging project :
        hub_logging_project_id = "<name of logging project>"
        
        The ID of the logging bucket :
        log_bucket_id = "<name of central log bucket>"
        
        The Spoke Folder ID for centralized logging :
        spoke_folder_id = "<id number of spoke folder>"
        
        The Hub Folder ID for centralized logging :
        hub_folder_id = "<id number of hub folder>"
        
        The Default region Name :
        region = "<name of the region>"

        The period of time, in seconds, that objects in the storage bucket must be retained :
        retention_policy_retention_period = "<numeric value>"
        
        The ID of the cloud storage bucket
        bucket_cloud_storage_name  = "<name of cloud storeage bucket>"
      ```    
      

3. Configure Terraform to store state in a Cloud Storage bucket

    - By default, Terraform stores state locally in a file named terraform.tfstate. This default configuration can make Terraform usage difficult for teams, especially when many users run Terraform at the sametime and each machine has its own understanding of the current infrastructure.

    - To help you avoid such issues, this section configures a remote state that points to a Cloud Storage bucket. Remote state is a feature of backends and, is configured in the backend.tf files—for example:

    - environments/main/backend.tf

        ```
        terraform {
        backend "gcs" {
        bucket = "terraform-state-bucket"
        prefix = "central-logging/terraform/state/env/"
        }
        }
        ```

4. Create & Execute CI/CD pipeline. 

Please follow this blog to configure and execute CI/CD pipeline in Google Cloud.  https://medium.com/@subnets_aircrew.0r/automating-iac-deployment-with-google-cloud-build-triggers-3f1fa1fbb722
    
		
5. Execution of the module will create Cloud Loging resources like Log Export Sink, 
	
<a name="management-view"/>

#### 4.2 Management View

The entire module is being managed as Infrastructure as Code. Once the automation CI/CD pipeline executes, resources; related to Cloud Logging module gets provisioned and starts operating. 

You can visit the Google Cloud Console to verify the required resource provisioned and status of the resources like Log sinks, Log Storage, Cloud Storage.

<a name="cleanup-view">

#### 4.3 Cleanup

If Centralized Logging has to be stopped then one needs to destroy the resources created by this module. The safe way to destroy/remove/cleanup, is to use the CI/CD pipeline. Trigger ```off-boarding``` pipeline manually to initiate the process of destruction.

To configure "off-boarding" pipeline follow steps of Section 9.2 Deployment Procedure Point number 6,  Pipeline Setup Step 1/2 Event "Repository event that invokes trigger" must be "Manual Invocation"

Otherwise we can use :

		```plaintext
		  terraform init
		  terraform plan
		  terraform destroy
		``` 
<a name="test-case">
	
## 10. Testing
Once the Terraform code executes, it deploys the Centralized Logging provisioning module. Listed below are key components that are deployed with configuration. As part of testing login to Google Cloud Console to perform following steps to validated the information noted in this section.

Validation Steps:
- Log Sink created on mentioned Project  ```Logging=>Log Router```
- Log Sink created on mentioned Folder  ```Logging=>Log Router```
- Log Bucket created on mentioned Project  ```Logging=>Log Storage```
- Storage Bucket for Archival logs on mentioned project  ```Cloud Storage=>Buckets```

<a name="known-problems-and-limitations">

## 11. Known problems and limitations

There are limitations &  respective solution identified.

https://cloud.google.com/logging/docs/buckets#deleting-logs-bucket

1. A deleted bucket stays in this pending state for 7 days, and Logging continues to route logs to the bucket during that time. To stop routing logs to a deleted bucket, you can delete the log sinks that have that bucket as a destination, or you can modify the filter for the sinks to stop routing logs to the deleted bucket.

   In case Log bucket crated using terraform and required to be deleted executing  ```terraform destroy``` log bucket will be destroyed and will not allow to create a new log bucket using this IaC automation until 7 days of deletion. It is also being observed permanent deletion of log bucket does not update terraform state. It leads to a error condition, to avoid this limitation its being suggested to created Log Bucket manually ( steps mentioned on Prerequisite section).  

Google Tech Note : https://cloud.google.com/logging/docs/buckets#deleting-logs-bucket



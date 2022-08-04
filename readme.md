# Servian Tech Challenge
Applicant: Zhenxin(Jackie) Li

## Overview of this project  
The project itself is a simple GTD application provided by the employer. The applicant has implemented a solution to perform the CD process. The solution scripts are inside the infra and ansible folders, as well as the CD pipeline in the .github/workflows directory.  

## How to use
### Pre-requisites for the solution
* A valid AWS Account and its credentials  
 
  To run the pipeline successfully, the user first needs to configure the secrets stored in github.  
  
  To update the secrets, navigate into repo settings, then find the Actions tab under Secrets, and update relative values into the secrets.  
  
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/githubSecrets.jpg?raw=true)  
  
  Any commits pushed or PRs raised to the repository would invoke the pipeline to run, if the pipeline doesn't return any errors it would be keep running 
  until the user clicks 'cancel workflow', this is because the `serve` command would take over the commandline.  
  
  Finally the user can check the deployed application by clicking the web instance address existing in the AWS EC2 service page. Note that the user might need to modify 
  the `https` into `http`.
  
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/Application.jpg?raw=true)    

## Architectural Overview  
  
  There are 3 main Terraform scripts have been created in regards of deploying infrastructures using code: `db.tf`, `ec2.tf`, and `vpc.tf`.  
  
  Each terraform file has its relative IaC scripts inside:  
  
### - db.tf
  
  The db terraform scripts creates 2 security groups to be used by the DB, and an actual postgres instance with desired paramaters.

### - ec2.tf

  The ec2 scripts creates the EC2 instance for deploying our web application with basic parameters, the instance's ami has been filtered to be always using the latest Linux image.  
  
  It also creates the deployer key pair which utilizes `~/.ssh/id_rsa.pub`, which is being generated in our github action's virtual machine.
  
### - vpc.tf

  This script creates the vpc and 9 subnets with size /22 with 3 layers (public, private, and data) across 3 availability zones, which provides us better 
  controllability of where services are hosted and what can access them.  
  
  Other infrastructures include an internet gateway enables resources to connect to the internet, a route table to determine where data packets traveling 
  over an Internet Protocol (IP) network will be directed. And finally is a load balancer and its listener attached to the web to distribute incoming 
  application traffic across multiple targets
  

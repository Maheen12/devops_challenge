# Grid Singularity Devops Challenge  

Your goals for this challenge:

1. Create an automation using Terraform or Cloudformation to provision one Linux VM in AWS capable to run docker containers and with the port 80 exposed to the internet.
2. Create a Dockerfile of a nginx container.
3. Create a CI/CD pipeline using Travis/Github Actions/Jenkins to build and deploy the container in the Linux VM.
4. Create a README with all necessary steps in order to run your automation.

We would like to see your considerations for credentials handling in this scenario.  
The challenge is expected to take between 2-4 hours.  

In order to submit your solution a fork of this repo has to be created, and the solution can be committed to the fork.


#########################################

Here are the prerequisites to run the solution:

* Anisble: Please follow the link to install ansible based on
your operating system: 
https://docs.ansible.com/ansible/latest/installation_guide/index.html
* Terraform: Please follow the link to install terraform:
https://learn.hashicorp.com/tutorials/terraform/install-cli
* An AWS account with access to EC2 and S3 bucket (used to store the 
terraform state files)
* Awscli (to store aws credentials)

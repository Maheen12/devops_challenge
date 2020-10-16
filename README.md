# Grid Singularity Devops Challenge  

Here are the prerequisites to run the solution:

* Anisble: Please follow the link to install ansible based on
your operating system: 
https://docs.ansible.com/ansible/latest/installation_guide/index.html
* Terraform: Please follow the link to install terraform:
https://learn.hashicorp.com/tutorials/terraform/install-cli
* An AWS account with access to EC2 and S3 bucket (used to store the 
terraform state files)
* Awscli (to store aws credentials)

Steps to follow:

1. Clone the repository on your local machine

2. Create a folder in your home directory and copy over the terraform
file from devops_challenge > terraform > connections.tf

3. Copy your AWS `private key` ( .pem ) to the same directory
`maheen@maheen:~/terraform$ ls
connections.tf  <name>.pem`

4. Replace `PATH TO THE AWS SSH KEY` in `connections.tf` with your `key name`
that you already copied in the directory and Run `terraform apply`
 i.e `key_name = "<PATH TO THE AWS SSH KEY>"` with `keyname = "name"`

5. Add AWS credentials to the AWSCLI
maheen@maheen:~/aws/terraform$ aws configure
AWS Access Key ID [****************]: 
AWS Secret Access Key [****************]: 
Default region name [us-east-1]: 

Please make sure you have the private key
in the selected region


6. Make sure you have access to the s3 bucket
`maheen@maheen:~/aws/terraform$ aws s3 ls
2020-10-16 01:11:41 testbucket12`

7. Run `terraform init` in the folder and follow instrtuctions.
You would have to pass on the `s3 bucket` id

8. Execute terraform apply. This should bring up an EC2 instance 
in AWS

9. Terraform statefiles would be stored in the S3 bucket

10. Login to AWS console and fetch the public DNS of your instance
i.e `ec1-1-1.74.compute-1.amazonaws.com`

11. Add and public DNS and SSH key path to the ansible inventory file
`
[docker]
ubuntu@ec1-1-1.74.compute-1.amazonaws.com ansible_ssh_private_key_file=<Path/to/the/ssh_key>
`

12. Run the ansible playbook in devops_challenge > ansible > setup.yml 

ansible-playbook <Path to the setup.yml file in ansible folder>

This shall install all the necessary packages including docker and setup 
webhook for container creation

13. Login to the EC2 instance and start the webhook

`ssh -i "PATH TO THE SSH KEY" ubuntu@ec1-1-1-74.compute-1.amazonaws.com`
`cd ~`
`webhook-linux-amd64/webhook -hooks webhooks/hooks.json -ip <Public DNS of the instance> 
-verbose > /dev/null 2>&1 &`

14. By now, the webhook should be UP and Running. You can test it by running
curl command on the Public DNS

`curl <http URL>:9000`

15. Update the `web_url` in `.git/workflows/cicd.yml`with the EC2 instance Public DNS

15. Now commit the changes to master. This shall trigger a CI pipeline in the AWS actions
which in return calls the webhook on the EC2 instance. 

This webhook pull the latest config for the website in 'webapp' folder and builds an ngnix container.

This conainter could be access by:
`http://publicDNS:8080`

This is my small website :)

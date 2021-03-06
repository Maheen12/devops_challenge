# Grid Singularity Devops Challenge  

## About this Project

* An Amazon EC2 instance is created using Terraform
* Configurations are applied using Ansible
* Docker file for a small webdevelopment project
* Github Actions is used to create a Pipeline which triggers whenever a commit is made
* The pipeline calls a webhook which is running on the EC2 instance
* The webhook pull latest confiugration from github and builds docker container

## Prerequisites

* Please follow the link to install ansible based on your operating system: 
  https://docs.ansible.com/ansible/latest/installation_guide/index.html
* Please follow the link to install terraform:
  https://learn.hashicorp.com/tutorials/terraform/install-cli
* An AWS account with access to EC2 and S3 bucket (used to store the terraform state files). Please make sure to have access to the public `ssh key, `access_key` and `secret_key`
* Aws cli (to store aws credentials)

## Steps to follow:

1. Clone the repository on your local machine

2. Create a folder in your home directory and copy over the terraform file from devops_challenge > terraform > connections.tf

3. Copy your AWS `private key` ( .pem ) to the same directory.
   ```maheen@maheen:~/terraform$ ls
      connections.tf  <name>.pem```

4. Replace `PATH TO THE AWS SSH KEY` in `connections.tf` with your `key name`
   i.e `key_name = "<PATH TO THE AWS SSH KEY>"` with `keyname = "name"`

5. Add AWS credentials to the AWSCLI.
   
   ```maheen@maheen:~/aws/terraform$ aws configure
   AWS Access Key ID [****************]: 
   AWS Secret Access Key [****************]: 
   Default region name [us-east-1]: ```

   Please make sure you have the private key in the selected region

6. Make sure you have access to the s3 bucket.
   ```maheen@maheen:~/aws/terraform$ aws s3 ls
   2020-10-16 01:11:41 testbucket12```

7. Run `terraform init` in the folder and follow instrtuctions. You would have to pass on the `s3 bucket` id.

   ```Initializing the backend...
   bucket
   The name of the S3 bucket

   Enter a value: bucketname


   Successfully configured the backend "s3"! Terraform will automatically 
   use this backend unless the backend configuration changes.

   Initializing provider plugins...
   - Finding latest version of hashicorp/aws...
   - Installing hashicorp/aws v3.11.0...
   - Installed hashicorp/aws v3.11.0 (signed by HashiCorp)

   The following providers do not have any version constraints in configuration,
   so the latest version was installed.

   To prevent automatic upgrades to new major versions that may contain breaking
   changes, we recommend adding version constraints in a required_providers block
   in your configuration, with the constraint strings suggested below.

   * hashicorp/aws: version = "~> 3.11.0"

   Terraform has been successfully initialized!```

8. Execute terraform apply. This should bring up an EC2 instance AWS.
   ```aws_instance.VM: Creating...
   aws_instance.VM: Still creating... [10s elapsed]
   aws_instance.VM: Still creating... [20s elapsed]
   aws_instance.VM: Creation complete after 27s [id=i-04wec1wd53fwf456bw]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.```


9. Terraform statefiles would be stored in the S3 bucket

10. Login to AWS console and fetch the public DNS of your instance.
    i.e `ec1-1-1.74.compute-1.amazonaws.com`

11. Add the public DNS and SSH key path to the ansible inventory file
    ```
    [docker]
    ubuntu@ec1-1-1.74.compute-1.amazonaws.com ansible_ssh_private_key_file=<Path/to/the/ssh_key>
    ```
12. Run the ansible playbook in devops_challenge > ansible > setup.yml 

    `ansible-playbook <Path to the setup.yml file in ansible folder>`

     This shall install all the necessary packages including docker and setup 
     webhook for container creation
13. Login to the EC2 instance and check status of the docker service
    
    login:
    `ssh -i "PATH TO THE SSH KEY" ubuntu@ec1-1-1-74.compute-1.amazonaws.com`
    
    check status:
    ```ubuntu@ip-1-1-1-74:~$ systemctl status docker
    ● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2020-10-16 08:22:12 UTC; 1min 4s ago
     Docs: https://docs.docker.com
     Main PID: 9541 (dockerd)
     Tasks: 8
     CGroup: /system.slice/docker.service
           └─9541 /usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375```

14. Start the webhook and it shall start listening on port `9000`

    ```cd ~
    wwebhook-linux-amd64/webhook -hooks webhooks/hooks.json -ip "Ip or Public DNS" --verbose > /dev/null 2>&1 &```

15. By now, the webhook should be UP and Running. You can test it by running
curl command on the Public DNS

    `curl <http URL>:9000`

16. Now final step would be to add the define `WEBHOOK_SECRET` and `WEBHOOK_URL` in the github project
    `WEBHOOK_SECRET`: It should be the same as defined in `webhooks/hooks.json` i.e `mysecret`
    `WEBHOOK_URL`: http://<FQDN of the EC2 instance>:9000/hooks/webhook

17. Now touch a test file in the repository and commit the changes. This shall trigger a pipeline using AWS actions
     which in return calls the webhook on the EC2 instance. 

    This webhook pull the latest config for the website in 'webapp' folder and builds an ngnix container.

    This conainter could be access by:
    `http://publicDNS:8080`

    This is my small website :)

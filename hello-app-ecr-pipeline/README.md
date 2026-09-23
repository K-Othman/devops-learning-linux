# hello-app-ecr-pipeline

A minimal CI/CD pipeline that builds a Docker image and pushes it to AWS ECR (Elastic Container Registry) on every push to `main`. Built as part of a CoderCo DevOps bootcamp challenge.

## What this does

1. A simple Node.js "hello world" app is containerized with Docker
2. On every push to `main`, GitHub Actions automatically:
   - Builds a fresh Docker image
   - Authenticates to AWS using a scoped IAM user
   - Pushes the image to an ECR repository, tagged with the commit SHA

The goal wasn't the app itself, it's a deliberately simple placeholder. The focus was building a real, working CI pipeline from infrastructure through deployment.

## Infrastructure (Terraform)

All AWS infrastructure is provisioned with Terraform, found in the `terraform/` folder:

* **ECR repository** (`hello-app`), with image scanning enabled on push
* **IAM user** (`github-actions-ecr-deploy`), dedicated solely to this pipeline, not a shared or admin account
* **IAM policy**, scoped to only the ECR permissions needed to push images, following least privilege rather than broad access
* **Policy attachment**, linking the user to the policy

No AWS credentials are hardcoded anywhere. The Terraform AWS provider reads local credentials automatically, and the GitHub Actions workflow authenticates using the IAM user's access keys, stored as encrypted GitHub Secrets.

## CI/CD pipeline (GitHub Actions)

Defined in `.github/workflows/deploy.yaml`, triggered on every push:

1. **Checkout** the repo
2. **Configure AWS credentials** using GitHub Secrets
3. **Log in to ECR**
4. **Build and push** the Docker image, tagged with `github.sha` rather than `latest`, so every image in the registry is traceable back to the exact commit that produced it

## Project structure

├── .github/workflows/deploy.yaml   # CI/CD pipeline definition
├── terraform/
│   └── main.tf                     # ECR repo, IAM user, policy, attachment
├── Dockerfile
├── server.js
├── package.json
└── README.md

## What I learned

* How to provision AWS infrastructure with Terraform and connect it to a CI pipeline
* The difference between IAM users and IAM roles, and why least privilege matters for CI credentials
* How the AWS credential chain works locally versus inside GitHub Actions
* Debugging a git repo root mismatch that caused the workflow file to sit outside version control entirely
* Why `terraform destroy` acts on state rather than your latest config changes, and why `force_delete` needs an `apply` first to take effect
* The distinction between ECR (image storage) and ECS (running containers), and keeping a pipeline scoped to exactly what the task requires

## Notes

This challenge was scoped to build and push only. Running the image (via ECS or otherwise) is out of scope here and is being tackled separately as a larger end to end project.

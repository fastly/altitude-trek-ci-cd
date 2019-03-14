<img src="https://www.fastly.com/assets/altitude-2019/logo-7d98253b75cd34465d3a4db5c22bb8505c128f91bff5f4ea1b314b0ad2b43b77.svg" width="300">

<h1>Building a continuous deployment pipeline<br/> with Terraform and Fastly</h1>

Demo repository for the talk _*Building a continuous deployment pipeline with Terraform and Fastly*_, first presented at [Altitude Trek SF](https://www.fastly.com/altitude/2019/san-francisco) 2019.

> In this session, you’ll walk through the process of creating a continuous deployment pipeline using Travis, Terraform, Fastly, and GitHub. We’ll introduce you to the core concepts needed to deploy a new version of your Fastly service via the API, as well as the benefits of automating this process. Along the way, you’ll gain practical, implementable tips and tricks for managing your infrastructure as code.


## Requirements
- [Terraform](https://www.terraform.io/) (>= 0.11.13)
- Git
- [Travis CI](https://travis-ci.org/) account
- [Google Cloud Platform](https://cloud.google.com/) (GCP) account
- [Fastly](https://www.fastly.com/) account


## Configuration
Fork this repository and clone to a local directory.

You will need a `terraform.tfvars` file containing the following access token variables:
```
FASTLY_API_TOKEN = "<YOUR FASTLY API TOKEN>"

GCP_PROJECT_ID = "<YOUR GCP PROJECT ID>"

GCS_ACCESS_KEY = "<YOUR GCP ACCESS KEY>"

GCS_SECRET_KEY = "<YOUR GCP SECRET KEY>"
```

You will also need a `.google.json` file containing the IAM credentials for a service account that has storage write acccess permissions. 

## Running
- `terraform workspace new staging`
- `terraform plan`
- `terraform apply`
- Make a change to `fastly_service_v1` resource in `main.tf`
- `git commit -am "Details of your change"`
- `git push origin master`

## License
[MIT](https://github.com/fastly/altitude-trek-ci-cd/blob/master/LICENSE)

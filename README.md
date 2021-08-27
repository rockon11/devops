# devops

This entire application can be designed as a simple microservice with a combination of Docker/Terraform files. 
Jenkins pipeline can be used to run the deployment.
ECS/EKS Framework will be helpful so the scaling can be put in place.
We can use terraform supported vault module to retrieve DATABASE_URLs.

data "vault_generic_secret" "devops-test" {
  path = "secret/devops-test"
}

resource "docker_container" "devops-test" {
  name = "devops-test"
  hostname = "devops-test"
  image = docker_image.devops-test.latest
  network_mode = "host"
  logs = true

  env = [
    "MONGODB_URL=${data.vault_generic_secret.devops-test.data["mongodb_url"]}",
    "REDIS_URL=${data.vault_generic_secret.devops-test.data["redis_url"]}"
  ]
}

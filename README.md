# wescaleCloudFunctionBooster

This project deploys a Cloud function to GCP using Cloud Build pipeline, at the time of writing this documentation the gitops pipeline is the folowing:
- push to a feature branch => will run a plan on prod and dev environments
- merge in dev branch => will deploy the function in dev environement
- merge in prod branch => will deploy the function in prod environement

Supported Git repositories are Github and Cloud Source repository (GCP git), a gitlab integration is ongoing

## Prerequisite 
- Install gcloud [gcloud](https://cloud.google.com/sdk/install)
- Install [terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
- Authenticate to your GCP project 
- You need to give the Cloud Build service account rights to create ressources in your GCP project, to do so you can give it editor role:

    ```
    PROJECT=<gcp_project_id>
    CLOUDBUILD_SA="$(gcloud projects describe $PROJECT --format 'value(projectNumber)')@cloudbuild.gserviceaccount.com"
    gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$CLOUDBUILD_SA --role roles/editor
    ```

## Repository setup
- **Github**  You need to install the Cloud Build Github App and connect your github repository to GCP, to do so follow this [documentation](https://cloud.google.com/cloud-build/docs/automating-builds/run-builds-on-github#installing_the_google_cloud_build_app)
- **Cloud Source Repository** terraform code is provided in ```setup``` directory, to create a CSR repository and Cloud build triggers:

    - The provided terrafrom uses service account impersonation, so first step you need to create a service account with project editor role and give your user permissions to generate an API token for it:
    ```
    PROJECT=<gcp_project_id>
    USER=<toto@wescale.fr>
    gcloud auth application-default login
    gcloud iam service-accounts create terrafrom-sa
    gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:terraform-sa@${PROJECT}.iam.gserviceaccount.com --role roles/editor
    gcloud iam service-accounts add-iam-policy-binding terraform-sa@${PROJECT}.iam.gserviceaccount.com --member user:${USER} --role roles/iam.serviceAccountTokenCreator
    ```
    - In  ```setup``` edit ```variables.tf``` to set the proper gcp project and choose a name for your repository then run ``terraform apply`` to create your repository
    - To push code inside the repository you have to run those commands:
    ```
    git config --global credential.https://source.developers.google.com.helper gcloud.sh
    git remote add google https://source.developers.google.com/p/<gcp_project_id>/r/<repository_name>
    git push --all google
    ```    
 ## Repository structure
     .
    ├── setup                   # Terraform files to setup a CSR and Cloud Build trigger
    ├── app                     # Source code for the cloud function 
    ├── modules                   
    │   └── cloudFunctions      # Terraform module to create the cloud function
    ├── envs                    # Terraform code to deploy the function in the environments
    │   ├── dev                 # DEV environement 
    │   └── prod                # PROD environement    
    └── cloudbuild.yaml         # Cloud Build pipeline
    
 ## Hints
*   To Add a new environement all what you need to do is to create a new environement directory in ```envs```, The branch name should match your environment name otherwise only ```terraform plan``` will be executed in the existing environements
*   By default the build project and the target deployment project are the same, you can choose to use different projects by setting the ```project``` variable in the envs, to do so you have to give Cloud Build service account the project editor role to deploy on this project.

    

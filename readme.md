# Deploying Shiny App to Google Cloud Platform

This process was inspired by Peer Christensen's "Dockerizing and Deploying a Shiny Dashboard on Google Cloud" article on Towards Data Science.  

I adapted and updated some of it to simplify and fit my needs.  

## Resources  

I have the following resources configured to enable this work:  

  * A personal Windows Laptop with Windows Subsystem Linux 2 (WSL2) installed for Ubuntu 22.04 LTS. On it I use `podman` rather than `docker` to do work with containers.  
  * A google account with:  
    * A domain name registered with the google domain service  
	* Billing established in [Google Cloud](https://www.cloud.google.com). The work described in this repository does not cost money but google requires billing information in order to open a container registry.  
	
## Step 1: Containerizing a Shiny Application  

This is fairly easy for a simple example. In this effort I'm focusing on the mechanics of deploying an application to google cloud so I'll take the path of least resistance when it comes to the actual shiny application. The `rocker/shiny-verse` container image comes with the stock basic shiny apps we are familiar with. I'll just use the "hello" app with the histogram of waiting times for this.  

My simple dockerfile just pulls the lastest `rocker/shiny-verse` container, updates the system packages, installs some required dependencies, exposes port 80, and runs the application.  

Container the application with:  

`podman build -t myapp .`

Test that it runs properly with:  

`podman run -d -p 8080:80 myapp:latest

## Step 2: Set up a project and container registry on Google Cloud  

Create a new project on [Google Cloud](https://cloud.google.com). Select "Artifact Registry" from the list of "More Products" under the "CI/CD" section. Click "Enable API". 

**Note:** You will not be able to do this if your billing has not been set up yet.

Once enabled, you should see a list of `gcr.io` URLs for different regions. At the time of this writing (08 December 2022), GCR (Google Container Registry) is being phased out and Google Artifcat Registry should be used instead. I selected the "Create Repository" button at the top of the page and went through the steps to create the registry path of: `us-east1-docker.pkg.dev/test-app-368721/my-registry`. This registry will house my project's container.

### Deploy Token

In order to push from GitLab CI to GCP Artifact Registry we will need a service account to authenticate with. That Service Account needs to have specific roles in order to deploy new container images to Cloud Run. Based on information in this Google Cloud Documentation about [Deploying Containers to Cloud Run](https://cloud.google.com/run/docs/deploying#permissions_required_to_deploy) I will give the Service Account the Cloud Run Admin and Service Account User roles.  

Create a service account in the UI by going to "IAM & Admin" -> "Service Accounts". Here click "Create Service Account." Give it a name and save it. For this example I used "gitlab-ci" as my service account name. If prompted, you can go ahead and apply the "Artifact Registry Writer" role at this point. This gives the service account permissions to write new containers to the registry. If you do not, that is ok. Follow the process below to add it later.  

Next, provide this service account with the `Service Account User` role to give it the required permissions to deploy a new service revision to Cloud Run. Do this by selecting the Runtime Service Account from the IAM & Admin -> Service Accounts UI. The Runtime Service Account is in this format: `<Project_number>-compute@developer.gserviceaccount.com`. First, copy your gitlab-ci service account's email address. Then click on the Runtime Service Account, navigate to "Permissions" on the next screen, select "Grant Access", paste the gitlab-ci email address as the "Principle", and select the "Service Account User" role. Then click save. Here is a helpful [Google Cloud Documentation](https://cloud.google.com/run/docs/reference/iam/roles#additional-configuration) page about this.  

Now back in the Artifact Registry section, check the box next to the repository you created in the previous step (`us-east1-docker.pkg.dev/test-app-368721/my-registry`). On the permissions panel on the far right, select "Add Principle." The principle name for the service account previously created should be something like: "gitlab-ci@test-app-368721.iam.gserviceaccount.com". Check in the IAM section to be clear. Give this principle the "Artifact Registry Writer" role and save the action.  

At this point we have the proper roles assigned to the service account required to authenticate with Google Cloud Platform and push a new container image to Google Artifact Registry for a specific project. We need the container in place before we can create a service and we need a service before we can apply the final required role of "Cloud Run Admin." That step will come late.

Head back to "IAM & Admin" -> "Service Accounts", find the service account you created (e.g. gitlab-ci), and select "Manage Keys" for the service account. Create a new key and download the JSON file.

In a bash, encode the json. You may need to install `base64` with `sudo apt-get install cl-base64 -y`.  

Once encoded, add this to the GitLab project as a CI/CD Variable. In this case I named it `GCP_REGISTRY_TOKEN`. Do this with the following command, ensuring to include the `-w0` so that the encoded key is a single line. In the GitLab CI Variable window, ensure to record the token as a file, not a variable. If not, you'll get a "file name too long" error.
```
base64 -w0 <json file>
```

Once added as a file type variable, log into the Google Cloud Platform Artifact Registry with the following podman command. Note that the username is a standard name for this type of action (always the same):  

```
base64 -d $GCP_REGISTRY_TOKEN | podman login -u _json_key --password-stdin us-east1-docker.pkg.dev/test-app-368721/my-registry
```  

The first step converts the character string back to the json format while the second step tells podman you are authenticating with a json file that is being passed via the standard in interface.  

The repository will be specific to your project. Within the GitLab-CI specification I do this in the "before_script" section. 

** [Colin Wilson's Post](https://colinwilson.uk/2020/07/10/configure-gitlab-ci-with-google-container-registry/) is a very helpful resource.  

## Step 4: Build, tag, and push the container with GitLab-CI

This is fairly easy given the provided docker file, the completed GitLab-CI Variables, and the GitLab-CI yaml specifications. logged in GCP Artifact Registry, and a CI Variable containing the desired registry name and container name.  

If all of these steps are complete, make all required commits to the GitLab project and then run the "build" and "publish" stages of the gitlab-ci.yaml specification. While these stages are set to run automatically on the "main" and "develop" branches, they can be run on all branches manually. Do this and ensure all complete successfully. If so, move on. If not, troubleshoot.

## Step 5: Deploy the app with Google Cloud Run  

Once the container image is successfully committed to Google Artifact Registry continue on.  

In Google Cloud Run, create a service.  

Follow these options:  

  * Select a container image (the one you just pushed)  
  * CPU allocation and pricing: CPU is only allocated during request processing  
  * Autoscaling is 0 to 10  
  * Ingress: Allow all traffic  
  * Authentication: Allow unauthenticated invocations  
  * General: Container port: 80  
  * Capacity: Memory: 256 MiB (if the app crashes on startup, it likely does not have enough memory. Google will give you this as an error in the metrics tab).  
  * Create  

## Step 6: Give the Service Account Permission to Revise the Service  

At this point you have a container image and the Cloud Run service required to run it.  

Now we want GitLab CI to tell Google Cloud Run to update the service to use the new container image when it successfully pushes. This is what the "revise" stage of the `gitlab-ci.yaml` does.  

In the Cloud Run UI, check the service you want to write to. In the side panel that opens to the right, select "Add Principle" under the permissions tab. Once open, in the "principle" section, paste the email address for the service account you created. Next, select the "Cloud Run Admin" role and select "Save."  

If you haven't made new commits on the GitLab project branch you used to deploy the container image then simply run the "revise" stage. If you have made changes, then run all of the stages again.

## Step 7: Test the app works  

Cloud Run will give you a unique URL once the container pulls and starts. Make sure it works as expected.  

In the Cloud Run Service's YAML you should be able to see the container used in the current deployment. Ensure that is the ended container.

## Step 8: Assign it to your custom domain  

Tell Google Cloud Run what sub-domain you want the app to hang onto in your custom domain. Then update the your domain server with the information Google Cloud Run provides. It will likely be in the form of a CNAME.
 

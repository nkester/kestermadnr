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

Create a new project on [Google Cloud](https://cloud.google.com). Open the project directory for that new project, open the cloud shell, and enable a container registry with: 

`gcloud services enable containerregistry.googleapis.com`  

**Note:** You will get an error if your billing has not been set up yet.

## Step 3: Install `gcloud` Command Line Tool`  

I installed this on my WSL2 machine. You could also do all of this in your own container for repeatability (#futureWork).  

Instructions to install it are on the [Google Cloud](https://cloud.google.com/sdk/docs/install#deb) website.  

Once installed, login to your google account with `gcloud auth login`. Follow the prompts to complete this step.  

## Step 4: Push container to google container registry with podman

Because I use podman rather than docker, log into the google container registry with the following command:  

`gcloud auth print-access-token | podman login -u oauth2accesstoken --password-stdin gcr.io`  

Re-tag the original container image to push it into the google container registry. 

`podman tag localhost/myapp:latest gcr.io/<PROJECT-ID>/myapp`  

Then push it with:

`podman push gcr.io/<PROJECT-ID>/myapp`  

## Step 5: Deploy the app with Google Cloud Run  

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
  
## Step 6: Test the app works  

Cloud Run will give you a unique URL once the container pulls and starts. Make sure it works as expected.  

## Step 7: Assign it to your custom domain  

Tell Google Cloud Run what sub-domain you want the app to hang onto in your custom domain. Then update the your domain server with the information Google Cloud Run provides. It will likely be in the form of a CNAME.
 

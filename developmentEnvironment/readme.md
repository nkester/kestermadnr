# Development Environment  

This dockerfile specifies a replica of the environment used during development. 

Run the container locally with the following command (fill in the missing components):  

`podman run -d -p 8082:8787 -v neil-work:/home/rstudio/project-analytics-files -e PASSWORD=<password> -e ROOT=TRUE registry.gitlab.com/nkester-personal-cloud/containers/rocker-rstudio-server/extended:4.2.2`
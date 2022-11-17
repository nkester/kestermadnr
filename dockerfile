# get shiny server plus tidyverse packages image
FROM docker.io/rocker/shiny-verse:latest

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev

# Make the ShinyApp available at port 80
EXPOSE 80

CMD R -e "options('shiny.port' = 80,shiny.host='0.0.0.0');shiny::runApp(appDir='/srv/shiny-server/01_hello')"
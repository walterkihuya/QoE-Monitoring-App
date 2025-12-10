# Use a base R image
FROM rocker/r-ver:4.3.1

# Install system libraries needed by shiny, plumber, and dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libsodium-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c('shiny', 'plumber', 'randomForest'), repos = 'https://cloud.r-project.org')"

# Set working directory inside the container
WORKDIR /app

# Copy the API/app code into the container
# This puts the contents of QoeApi (including app.R and best_model.rds) into /app
COPY QoeApi /app

# Expose the port shiny will listen on
EXPOSE 8000

# Start the Shiny app
CMD R -e "shiny::runApp('app.R', host = '0.0.0.0', port = 8000)"

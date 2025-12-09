# Base R image
FROM rocker/r-ver:4.3.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('plumber', 'randomForest'), repos='https://cloud.r-project.org')"

# Work directory inside container
WORKDIR /app

# IMPORTANT: this name MUST match the folder name on GitHub
COPY QoeApi /app

# Expose Plumber port
EXPOSE 8000

# Start Plumber API
CMD R -e "pr <- plumber::plumb('app.R'); pr$run(host='0.0.0.0', port=8000)"

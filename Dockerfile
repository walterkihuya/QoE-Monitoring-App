# Use a base R image
FROM rocker/r-ver:4.3.1

# Install system libraries needed by plumber and its dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libsodium-dev \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c('plumber', 'randomForest'), repos = 'https://cloud.r-project.org')"

# Set working directory inside the container
WORKDIR /app

# Copy the API code from your repository into the container
# IMPORTANT: 'QoeApi' must match the folder name in your GitHub repo EXACTLY
COPY QoeApi /app

# Expose the port plumber will listen on
EXPOSE 8000

# Start the plumber API
CMD R -e "pr <- plumber::plumb('app.R'); pr$run(host = '0.0.0.0', port = 8000)"


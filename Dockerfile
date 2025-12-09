FROM rocker/r-ver:4.3.1

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('plumber', 'randomForest'), repos='https://cloud.r-project.org')"

WORKDIR /app

# Folder name MUST match what is on GitHub: QoeApi
COPY QoeApi /app

EXPOSE 8000

CMD R -e "pr <- plumber::plumb('app.R'); pr$run(host='0.0.0.0', port=8000)"


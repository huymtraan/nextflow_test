# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set DEBIAN_FRONTEND to noninteractive to avoid tzdata configuration prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies in a single step
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev \
    wget \
    curl \
    gnupg \
    software-properties-common \
    dirmngr \
    libcurl4-openssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    gfortran \
    libreadline-dev \
    tzdata \
    libx11-dev \
    libxext-dev \
    libxt-dev \
    libxrender-dev \
    libbz2-dev \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    bowtie \
    bwa \
    fastqc \
    fastp \
    samtools \
    git \
    pandoc \
    libcairo2 \
    libpango1.0-dev \
    libgtk-3-dev \
    libgdk-pixbuf2.0-dev \
    libcairo2-dev \
    libxt-dev \
    libcurl4-openssl-dev \
    xorg-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Ensure python3 is correctly linked
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install R 4.3.3
RUN wget https://cran.r-project.org/src/base/R-4/R-4.3.3.tar.gz -P /tmp && \
    tar -xzvf /tmp/R-4.3.3.tar.gz -C /tmp && \
    cd /tmp/R-4.3.3 && \
    ./configure --with-cairo --enable-R-shlib && \
    make -j$(nproc) && \
    make install

# Install R dependencies in a single step
RUN R -e "install.packages(c('ggplot2', 'dplyr', 'tidyr', 'data.table', 'BiocManager','ggfortify','tibble','kableExtra', 'MASS', 'stringi', 'Cairo', 'rmarkdown', 'knitr'), repos='https://cloud.r-project.org')" \
    && R -e "BiocManager::install(c('DESeq2', 'edgeR', 'Rsamtools', 'DNAcopy'))"

# Install Python dependencies
RUN pip3 install --no-cache-dir \
    scipy==1.13.0 \
    scikit-learn==1.4.2 \
    pysam==0.22.0 \
    numpy==1.26.4 \
    matplotlib==3.8.4 \
    pandas \
    statsmodels \
    multiqc \
    git+https://github.com/CenterForMedicalGeneticsGhent/WisecondorX

# Set working directory
WORKDIR /app
COPY bin/ /app/bin/
COPY assets /app/assets

# Set execution permissions for scripts
RUN chmod +x /app/bin/*.py

# Add scripts to PATH
ENV PATH="/app/bin:${PATH}"

# Default command
CMD ["python3", "--version"]

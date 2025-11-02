# Base image
FROM ubuntu:24.04

# GitHub Runner version
ARG RUNNER_VERSION="2.322.0"

# Create non-root user
RUN apt-get update -y && apt-get upgrade -y \
    && useradd -m docker

# Install system packages (Node, PHP, Python, MySQL client, git, wget, unzip, etc.)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip \
    openssh-client rsync wget zip unzip vim git php php-cli php-mbstring php-curl \
    php-zip php-xml php-intl php-sqlite3 default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 24.x LTS - specific Node minor version (for reproducibility)
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs=24.1.0-1nodesource1 \
    && npm install -g npm@latest

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install Playwright system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libxss1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2t64 \
    libpangocairo-1.0-0 \
    libpango-1.0-0 \
    libgtk-3-0 \
    libx11-xcb1 \
    libx11-6 \
    libxcb1 \
    libxext6 \
    fonts-liberation \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create directories for cache and dist
RUN mkdir /cache /dist && chown docker:docker /cache /dist && chmod g+w /cache /dist

# Download and unzip GitHub Actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Copy start script
COPY start.sh /home/docker/start.sh
RUN chmod +x /home/docker/start.sh

# Switch to non-root user
USER docker
WORKDIR /home/docker

# Entrypoint
ENTRYPOINT ["./start.sh"]

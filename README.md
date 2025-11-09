# Dockerized GitHub Self-Hosted Runner

This repository provides a **Docker-based GitHub Actions self-hosted runner** designed for fast, reproducible CI execution.
It is lightweight, easy to deploy, and ideal for local or remote automation (VPS, home lab, cloud instance).

## ✅ Features

* **Fully Dockerized** GitHub Actions runner
* Automatic registration to any repository via GitHub token
* Optional **multi-runner** setup using Docker Compose (replicas)
* Includes common build tools:

  * Node.js
  * PHP & Composer
  * MySQL client
  * Git
  * Curl / zip / unzip
* Clean shutdown & automatic removal on container exit
* Works with **Linux hosts** (Ubuntu recommended)

## ✅ Usage

1. Create a GitHub registration token in
   **Settings → Actions → Runners → New self-hosted runner**

2. Copy `.env.example` to `.env` and add:

   ```
   REPO_URL=https://github.com/<user>/<repo>
   RUNNER_TOKEN=<your_github_token>
   ```

3. Start the runner:

   ```
   docker compose up -d
   ```

4. Your runner will appear automatically under
   **Actions → Runners → Self-hosted**

## ✅ Scaling (optional)

You can scale multiple runners easily:

```
docker compose up -d --scale runner=3
```

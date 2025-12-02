# Google Ads ELT Pipeline

## Project Goal

## Tabel of Contents

## Technologies & Tools
#### Google Cloud Platform
- Google Cloud Storage (GCS) - Data Lake as staging area
- BigQuery - Data Warehouse to store structred and transformed data
- Looker Studio - For visualization
#### Orchestration & Transformation
- Apache Airflow - Pipeline orchestration
- dbt Core - For data transformation and data models creation
#### Enviroment & Language
- Docker & Docker Compose - For local development
- Python - Programming Language for extract & load scripts
## Pipeline
![elt-pipeline](/images/ELT_Pipeline_Diagram.png)
## Project Reproduction (Try it Yourself)
1. Clone the repository:
```bash
git clone https://github.com/yueyue426/google-ads-elt-pipeline.git
```
2. Set Up Enviroment:
   - Set Up GCP:
     - Create a GCP account if you don't have one.
     - Create a Project 
     - Create a Service Account in IAM & Admin
     - Create a Key and download the JSON file
   - Download & Install Docker Desktop:
     - [Install Docker Desktop on Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
     - [Install Docker Desktop on Mac](https://docs.docker.com/desktop/setup/install/mac-install/)
   - In your project directory, create a `profiles.yml`:
     ```yml
        # profiles.yml content (Place this in your project root)
        google_ads_dbt_project: 
        target: dev
        outputs:
            dev:
            type: bigquery
            method: service-account
            project: [YOUR-GCP-PROJECT-ID]
            dataset: analytics            
            threads: 4
            keyfile: /opt/airflow/gcp/credentials/[Your-Key-JSON-FILE].json
            timeout_seconds: 300
            location: US
      ```
   - Create a `.env` to set up enviroment variables:
     ```
     AIRFLOW_UID=[YOUR_UID]
     AIRFLOW_GID=[YOUR_GID]
     ```
     you can check your uid and gid using the commands:
     ```bash
     id -u # UID
     id -g # GID
     ```
   - Build & Start Docker Compose
     ```bash
     docker compose up -d --build
     ```
   - Initailize Airflow:
     ```bash
     docker compose exec airflow-webserver airflow db init
     ```
   - Access Airflow at: http://localhost:8080
   - Create `google_cloud_default` Connection:
     - In your Airlfow ui, navigate to the Connections Page: Go to **Admin** -> **Connections**.
     - Create a New Connection: Click the blue `+` button.
     - Enter the Configuration:
       ```
       ConnId: google_cloud_default
       ConnType: Google Cloud
       Keyfile Path: /opt/airflow/gcp/credentials/[Your-Key-JSON-FILE].json
       Project Id: Your GCP Project ID
       ```
     - Save and Close




## Visualization
You can access the report [here](https://lookerstudio.google.com/reporting/c85c2327-9323-44e3-a31c-ff61b626e581).
![performance](/images/Google_Ads_Performance_Overview.png)
## Future Improvements







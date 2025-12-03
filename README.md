# Google Ads ELT Pipeline

The goal of this project is to practice building an end-to-end ELT data pipeline using modern data engineering tools such as Airflow, dbt, Docker, and Google Cloud. The pipeline processes unstructured advertising logs and transforms them into a high-performance Star Schema within BigQuery, enabling efficient analytics and BI reporting in Looker Studio.
This project focuses on ensuring data quality, consistency, and delivering a low-latency analytics layer suitable for real-world reporting use cases.

## Tabel of Contents
- [Technologies & Tools](#technologies--tools)
- [Dataset](#dataset)
- [Pipeline Diagram](#pipeline-diagram)
- [Project Reproduction](#project-reproduction)
- [Project Structure](#project-structure)
- [Visualization](#visualization)
- [Future Improvements](#future-improvements)

## Technologies & Tools
#### Google Cloud Platform
- **Google Cloud Storage** (GCS) - Data Lake as staging area
- **BigQuery** - Data Warehouse to store structred and transformed data
- **Looker Studio** - For visualization
#### Orchestration & Transformation
- **Apache Airflow** - Pipeline orchestration
- **dbt Core** - For data transformation and data models creation
#### Enviroment & Language
- **Docker & Docker Compose** - For local development
- **Python** - Programming Language for extract & load scripts

## Dataset
The dataset used in this project is downloaded from Kaggle: [Google Ads sales dataset](https://www.kaggle.com/datasets/nayakganesh007/google-ads-sales-dataset). It closely resembles real-world exported advertising data that digital marketers and analysts typically work with — including typos, inconsistent formatting, missing values, mixed casing, and other data quality issues. The dataset contains 1,600 rows and 13 columns, described below:
- **Ad_ID** - Unique identifier for each ad campaign.
- **Campaign_Name** - Name of the campaign (includes typos and naming variations).
- **Clicks** - Number of user clicks on the ad.
- **Impression** - Number of times the ad was shown on a screen.
- **Cost** - Total ad spend (stored as a string with $ symbols and missing values).
- **Leads** - Number of leads generated.
- **Conversions** - Number of actual conversions (sales, signups, etc.).
- **Conversion_Rate** - Calculated as Conversions / Clicks.
- **Sales_Amount** - Revenue generated from conversions.
- **Ad_Date** - Date of the ad activity (presented in inconsistent date formats).
- **Location - City where the ad was served (with spelling or case inconsistencies).
- **Device** - Device type (Mobile, Desktop, Tablet, with mixed casing).
- **Keyword** - Search keyword that triggered the ad (contains typos and variations).

## Pipeline Diagram
![elt-pipeline](/images/ELT_Pipeline_Diagram.png)

## Project Reproduction (Try it Yourself)
1. Clone the repository:
```bash
git clone https://github.com/yueyue426/google-ads-elt-pipeline.git
cd google-ads-elt-pipeline
```
2. Set Up GCP:
   - Create a GCP account (if you don't already have one).
   - Create a GCP Project.
   - In **IAM & Admin**, create a Service Account.
   - Create a Key for the service account and download the JSON file.
   - Create a Cloud Storage bucket (GCS Bucket) to store your raw data.
3. Set Up Docker:
   - Download & Install Docker Desktop:
     - [Install Docker Desktop on Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
     - [Install Docker Desktop on Mac](https://docs.docker.com/desktop/setup/install/mac-install/)
4. Set Up Airflow & dbt:
   - In your project directory, create folders for Airflow so it can share files and logs between the host machine and the Docker containers:
     ```bash
     mkdir -p ./dags ./logs ./plugins
     ```
   - In your project root, create a `profiles.yml` file with following content (adjust values in brackets):
     ```yml
        google_ads_dbt_project: 
        target: dev
        outputs:
            dev:
            type: bigquery
            method: service-account
            project: [YOUR_GCP_PROJECT_ID]
            dataset: analytics            
            threads: 4
            keyfile: /opt/airflow/gcp/credentials/[YOUR_KEY_JSON_FILE].json
            timeout_seconds: 300
            location: US
      ```
   - Create a `.env` to set enviroment variables for Airflow:
     ```
     AIRFLOW_UID=[YOUR_UID]
     AIRFLOW_GID=[YOUR_GID]
     ```
     You can check your UID and GID with:
     ```bash
     id -u # UID
     id -g # GID
     ```
   - Update constant variables in `google_ads_elt_dag.py` if neccessary:
     ```
     GCP_PROJECT_ID = [YOUR_GCP_PROJECT_ID]
     GCS_BUCKET = [YOUR_GCS_BUCKET_NAME]
     GCS_BLOB_PATH = [PATH_IN_BUCKET_TO_RAW_DATA]
     LOCAL_CSV_PATH = [LOCAL_PATH_TO_ROW_DATA]
     BQ_DATASET = 'raw'
     BQ_TABLE = 'ads_raw'
     ```
5. Build & Start Docker containers (Docker Compose)
```bash
docker compose up -d --build
```
6. Initailize Airflow:
```bash
docker compose exec airflow-webserver airflow db init
```
7. Access Airflow UI at: http://localhost:8080
   - Create the `google_cloud_default` Connection:
     - In the Airlfow UI, Go to **Admin** -> **Connections**.
     - Click the blue **`+`** button to create a new connection.
     - Enter the Configuration:
       - **Conn Id**: `google_cloud_default`
       - **ConnType**: `Google Cloud`
       - **Keyfile Path**: `/opt/airflow/gcp/credentials/[YOUR_KEY_JSON_FILE].json`
       - **Project Id**: Your GCP project ID
     - Click **Save**.
8. Run the Airflow DAG
   - In the Airflow UI, find the DAG (e.g. `google_ads_elt_dag`)
   - Toggle it On if needed.
   - Click the **Trigger** DAG button to run the pipeline.
![dags](images/dags.png)

## Project Structure
```
.
├── dags/
│   └── google_ads_elt_dag.py          # Airflow DAG for ELT pipeline
│
├── logs/                               # Airflow logs (auto-generated)
│   └── ... 
│
├── plugins/                            # Custom Airflow plugins (optional)
│   └── ...
│
├── dbt/
│   └── google_ads_dbt_project/         # dbt transformation project
│       ├── models/                     # dbt models (staging + marts)
│       └── ...
│
├── data/
│   └── raw/
│       └── ads_raw.csv                 # Raw Google Ads data (CSV)
│
├── secrets/
│   └── google_service_account_key.json # Service account credentials
│
├── .env                                 # Environment variables for Docker/Airflow
├── docker-compose.yaml                  # Docker services (Airflow, dbt, etc.)
├── Dockerfile                           # Container image for Airflow + dbt
├── profiles.yml                         # dbt profile for BigQuery connection
├── requirements.txt                     # Python dependencies
└── README.md                            # Project documentation
```

## Visualization
You can access the report [here](https://lookerstudio.google.com/reporting/c85c2327-9323-44e3-a31c-ff61b626e581).
![performance](/images/Google_Ads_Performance_Overview.png)

## Future Improvements







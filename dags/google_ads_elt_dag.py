from datetime import datetime, timedelta
from google.cloud import storage
from airflow.models import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.google.cloud.operators.gcs_to_bigquery import GCSToBigQueryOperator

# Constants configuration
GCS_BUCKET = 'ads-raw-bucket'
GCS_BLOB_PATH = 'raw/ads_sales.csv'
LOCAL_CSV_PATH = './data/raw/GoogleAds_DataAnalytics_Sales_Uncleaned.csv'
BQ_DATASET = 'raw'
BQ_TABLE = 'ads-raw-bucket'

# Upload local file to GCS
def upload_to_gcs(bucket_name, gcs_blob_path, local_file):
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    blob = bucket.blob(gcs_blob_path)
    blob.upload_from_filename(local_file)

    print(f"Uploaded {local_file} to gs://{bucket_name}/{gcs_blob_path}")
    return f"gs://{bucket_name}/{gcs_blob_path}"

# Define default arguments for the DAG
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=1),
}

# DAG definition
with DAG(
    dag_id="google_ads_elt_pipeline",
    default_args=default_args,
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
    tags=['elt', 'gcp', 'dbt']
) as dag:
    
    # Task 1: Upload local CSV to GCS
    upload_data_to_gcs = PythonOperator(
        task_id='upload_csv_to_gcs',
        python_callable=upload_to_gcs,
        op_kwargs={
            'bucket_name': GCS_BUCKET,
            'gcs_blob_path': GCS_BLOB_PATH,
            'local_file': LOCAL_CSV_PATH
        }
    )

    # Task 2: Load GCS data into BigQuery
    load_gcs_to_bigquery = GCSToBigQueryOperator(
        task_id='gcs_to_bigquery',
        bucket=GCS_BUCKET,
        source_objects=[GCS_BLOB_PATH],
        destination_project_dataset_table=f"{BQ_DATASET}.{BQ_TABLE}",
        source_format='CSV',
        skip_leading_rows=1,
        write_diposition='WRITE_TRUNCATE',
        autodetect=True,
    )


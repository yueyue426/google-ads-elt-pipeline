# Start from the official Airflow image
FROM apache/airflow:3.1.3

# Install the dependencies from requirements.txt
USER root
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
USER airflow
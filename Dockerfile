# Start from the official Airflow image
FROM apache/airflow:3.1.3

# Switch to roor to run system-level commands
USER root

# Install the dependencies from requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Switch back to the Airflow user for security
USER airflow
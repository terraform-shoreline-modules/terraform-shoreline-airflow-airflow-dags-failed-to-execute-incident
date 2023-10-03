

#!/bin/bash



# Set the desired number of workers and resources

num_workers=${NUM_WORKERS}

cpu_cores=${CPU_CORES}

memory=${MEMORY}



# Stop the Airflow scheduler and workers

systemctl stop airflow-scheduler

systemctl stop airflow-worker



# Update the Airflow configuration file with the desired settings

sed -i "s/executor = LocalExecutor/executor = CeleryExecutor/" /etc/airflow/airflow.cfg

sed -i "s/parallelism = 32/parallelism = $num_workers/" /etc/airflow/airflow.cfg

sed -i "s/dags_are_paused_at_creation = True/dags_are_paused_at_creation = False/" /etc/airflow/airflow.cfg

sed -i "s/worker_concurrency = 16/worker_concurrency = $num_workers/" /etc/airflow/airflow.cfg

sed -i "s/cpu_cores = 4/cpu_cores = $cpu_cores/" /etc/airflow/airflow.cfg

sed -i "s/memory = 8GB/memory = $memory/" /etc/airflow/airflow.cfg



# Start the Airflow scheduler and workers

systemctl start airflow-scheduler

systemctl start airflow-worker



echo "Airflow environment has been configured with $num_workers workers, $cpu_cores CPU cores, and $memory memory."

### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Airflow DAGs Failed to Execute Incident
---

Airflow DAGs Failed to Execute Incident refers to an issue where the Directed Acyclic Graphs (DAGs) in Apache Airflow, a popular open-source platform to programmatically author, schedule, and monitor workflows, have failed to execute as expected. This can result in delays or failures in executing tasks that are integral to the workflow, leading to potential disruptions in the entire system.

### Parameters
```shell
export AIRFLOW_DAG_FOLDER="PLACEHOLDER"

export DAG_ID="PLACEHOLDER"

export TASK_ID="PLACEHOLDER"

export MEMORY="PLACEHOLDER"

export CPU_CORES="PLACEHOLDER"

export NUM_WORKERS="PLACEHOLDER"
```

## Debug

### Check if Airflow webserver is running
```shell
sudo systemctl status airflow-webserver.service
```

### Check if Airflow scheduler is running
```shell
sudo systemctl status airflow-scheduler.service
```

### Check if there are any errors in Airflow logs
```shell
sudo tail -f /var/log/airflow/*.log
```

### Check if DAGs are present in the Airflow dag folder
```shell
ls ${AIRFLOW_DAG_FOLDER}
```

### Check if DAGs are parsing correctly
```shell
airflow list_dags -sd ${AIRFLOW_DAG_FOLDER}
```

### Check if tasks are listed correctly in the DAG
```shell
airflow list_tasks ${DAG_ID}
```

### Check if task instances are running and not in a failed state
```shell
airflow task_state ${DAG_ID} ${TASK_ID}
```

### Check if task logs are showing any errors
```shell
airflow logs ${DAG_ID} ${TASK_ID}
```

### Check if dependencies for a DAG are met
```shell
airflow test ${DAG_ID} ${TASK_ID}
```

### Check if there are any issues with database connections
```shell
airflow connections
```

### Check if there are any issues with variables
```shell
airflow variables
```

### Check if there are any issues with plugins
```shell
airflow plugins
```

### Resource constraints: The Airflow server may not have enough resources to execute the DAGs. This could include issues with memory, CPU, or other resources that prevent the DAGs from being executed.
```shell


#!/bin/bash



# Check CPU usage

CPU_USAGE=$(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}')

CPU_THRESHOLD=80



if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then

    echo "CPU usage is high"

fi



# Check memory usage

MEM_USAGE=$(free | grep Mem | awk '{printf "%.2f\n", $3/$2 * 100.0}')

MEM_THRESHOLD=80



if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then

    echo "Memory usage is high"

fi



# Check disk space

DISK_USAGE=$(df -h | awk '{if ($NF == "/") {print $5}}' | sed 's/%//g')

DISK_THRESHOLD=80



if (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) )); then

    echo "Disk space is running low"

fi


```

## Repair

### Ensure that the Airflow environment is configured correctly, with the correct number of workers and resources allocated.
```shell


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


```
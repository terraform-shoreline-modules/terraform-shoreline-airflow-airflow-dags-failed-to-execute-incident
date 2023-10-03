resource "shoreline_notebook" "airflow_dags_failed_to_execute_incident" {
  name       = "airflow_dags_failed_to_execute_incident"
  data       = file("${path.module}/data/airflow_dags_failed_to_execute_incident.json")
  depends_on = [shoreline_action.invoke_cpu_mem_disk_check,shoreline_action.invoke_config_airflow_environment]
}

resource "shoreline_file" "cpu_mem_disk_check" {
  name             = "cpu_mem_disk_check"
  input_file       = "${path.module}/data/cpu_mem_disk_check.sh"
  md5              = filemd5("${path.module}/data/cpu_mem_disk_check.sh")
  description      = "Resource constraints: The Airflow server may not have enough resources to execute the DAGs. This could include issues with memory, CPU, or other resources that prevent the DAGs from being executed."
  destination_path = "/agent/scripts/cpu_mem_disk_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "config_airflow_environment" {
  name             = "config_airflow_environment"
  input_file       = "${path.module}/data/config_airflow_environment.sh"
  md5              = filemd5("${path.module}/data/config_airflow_environment.sh")
  description      = "Ensure that the Airflow environment is configured correctly, with the correct number of workers and resources allocated."
  destination_path = "/agent/scripts/config_airflow_environment.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cpu_mem_disk_check" {
  name        = "invoke_cpu_mem_disk_check"
  description = "Resource constraints: The Airflow server may not have enough resources to execute the DAGs. This could include issues with memory, CPU, or other resources that prevent the DAGs from being executed."
  command     = "`chmod +x /agent/scripts/cpu_mem_disk_check.sh && /agent/scripts/cpu_mem_disk_check.sh`"
  params      = []
  file_deps   = ["cpu_mem_disk_check"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_mem_disk_check]
}

resource "shoreline_action" "invoke_config_airflow_environment" {
  name        = "invoke_config_airflow_environment"
  description = "Ensure that the Airflow environment is configured correctly, with the correct number of workers and resources allocated."
  command     = "`chmod +x /agent/scripts/config_airflow_environment.sh && /agent/scripts/config_airflow_environment.sh`"
  params      = ["CPU_CORES","NUM_WORKERS","MEMORY"]
  file_deps   = ["config_airflow_environment"]
  enabled     = true
  depends_on  = [shoreline_file.config_airflow_environment]
}


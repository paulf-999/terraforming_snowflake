output "table_airflow_dag" {
  value = snowflake_table.table_airflow_dag.name
}

output "table_airflow_dag_run" {
  value = snowflake_table.table_airflow_dag.name
}

output "sequence_airflow_dag_seq" {
  value = snowflake_sequence.sequence_airflow_dag_seq.name
}

output "sequence_airflow_dag_run_seq" {
  value = snowflake_sequence.sequence_airflow_dag_run_seq.name
}

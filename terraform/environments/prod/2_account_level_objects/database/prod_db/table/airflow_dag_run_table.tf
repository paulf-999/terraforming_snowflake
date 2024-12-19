resource "snowflake_table" "table_airflow_dag_run" {

  database = var.db_name_prod_db
  schema   = var.schema_name_prod_airflow
  name     = upper("airflow_dag_run")

  # Note: the sequence should be created prior to the table
  depends_on = [snowflake_sequence.sequence_airflow_dag_run_seq]

  column {
    name     = "ID"
    type     = "NUMBER(38,0)"
    nullable = false
    default {
      sequence = snowflake_sequence.sequence_airflow_dag_run_seq.fully_qualified_name
    }
  }

  column {
    name = "DAG_NAME"
    type = "VARCHAR(255)"
  }

  column {
    name = "DAG_RUN"
    type = "VARCHAR(255)"
  }

  column {
    name = "DAG_RUN_STATE"
    type = "VARCHAR(50)"
  }

  column {
    name = "DAG_RUN_START_DATE"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name = "DAG_RUN_END_DATE"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name = "DAG_RUN_DURATION_SECONDS"
    type = "NUMBER(18,0)"
  }

  column {
    name = "TASK_NAME"
    type = "VARCHAR(255)"
  }

  column {
    name = "TASK_STATE"
    type = "VARCHAR(50)"
  }

  column {
    name = "TASK_START_DATE"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name = "TASK_END_DATE"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name = "TASK_DURATION_SECONDS"
    type = "VARCHAR"
  }

  column {
    name = "QUERY_TS_UTC"
    type = "TIMESTAMP_NTZ(9)"
    default {
      expression = "CURRENT_TIMESTAMP()"
    }
  }
}

resource "snowflake_sequence" "sequence_airflow_dag_run_seq" {

  database = var.db_name_prod_db
  schema   = var.schema_name_prod_airflow
  name     = "AIRFLOW_DAG_RUN_SEQ"
}

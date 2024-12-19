resource "snowflake_table" "table_airflow_dag" {

  database = var.db_name_prod_db
  schema   = var.schema_name_prod_airflow
  name     = upper("airflow_dag")

  # Note: the sequence should be created prior to the table
  depends_on = [snowflake_sequence.sequence_airflow_dag_seq]

  column {
    name     = "ID"
    type     = "NUMBER(38,0)"
    nullable = false
    default {
      sequence = snowflake_sequence.sequence_airflow_dag_seq.fully_qualified_name
    }
  }

  column {
    name = "DAG_NAME"
    type = "VARCHAR(255)"
  }

  column {
    name = "DESCRIPTION"
    type = "VARCHAR"
  }

  column {
    name = "TAGS"
    type = "VARCHAR(255)"
  }

  column {
    name = "DAG_SCHEDULE"
    type = "VARCHAR(50)"
  }

  column {
    name = "LAST_DAG_RUN"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name = "NEXT_DAG_RUN"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name = "QUERY_TS_UTC"
    type = "TIMESTAMP_NTZ(9)"
    default {
      expression = "CURRENT_TIMESTAMP()"
    }
  }
}

resource "snowflake_sequence" "sequence_airflow_dag_seq" {

  database = var.db_name_prod_db
  schema   = var.schema_name_prod_airflow
  name     = upper("airflow_dag_seq")
}

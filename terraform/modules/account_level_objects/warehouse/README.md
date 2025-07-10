# Snowflake Warehouse Terraform Module

This Terraform module creates and manages a Snowflake warehouse in a repeatable manner.
## Usage

```hcl
module "snowflake_warehouse" {
  source = "./modules/account_level_objects/warehouse"
  # Mandatory fields
  sf_warehouse_name      = "example_warehouse"  # The name of the Snowflake warehouse
  sf_warehouse_size      = "SMALL"              # The size of the Snowflake warehouse
  # Optional fields
  comment                = "Eg comment."        # Comment for the warehouse
  max_cluster_count      = 2                    # Maximum number of clusters
  min_cluster_count      = 1                    # Minimum number of clusters
  sf_wh_scaling_policy   = "STANDARD"           # Scaling policy (STANDARD or ECONOMY)
  max_concurrency_level  = 8                    # Maximum concurrent SQL statements
}
```

## Inputs

| Name                   | Description                                                                 | Type   | Default     | Required |
|------------------------|-----------------------------------------------------------------------------|--------|-------------|----------|
| `sf_warehouse_name`    | The name of the Snowflake warehouse.                                       | string |             | yes      |
| `comment`              | Comment for the Snowflake warehouse.                                       | string | `null`      | no       |
| `sf_warehouse_size`    | The size of the Snowflake warehouse (e.g., XSMALL, SMALL, MEDIUM, etc.).    | string |             | yes      |
| `max_cluster_count`    | Maximum number of clusters for the warehouse.                              | number | `1`         | no       |
| `min_cluster_count`    | Minimum number of clusters for the warehouse.                              | number | `1`         | no       |
| `sf_wh_scaling_policy` | The scaling policy for the Snowflake warehouse (e.g., STANDARD, ECONOMY).   | string | `STANDARD`  | no       |
| `max_concurrency_level`| The maximum number of concurrent SQL statements that can be executed.       | number | `1`         | no       |

## Outputs

| Name             | Description                           |
|------------------|---------------------------------------|
| `warehouse_name` | The name of the Snowflake warehouse. |

## Example

```terraform
module "snowflake_warehouse" {
  source = "./modules/account_level_objects/warehouse"
  sf_warehouse_name      = "analytics_warehouse"
  sf_warehouse_size      = "MEDIUM"
  comment                = "Warehouse for analytics workloads."
  max_cluster_count      = 3
  min_cluster_count      = 1
  sf_wh_scaling_policy   = "ECONOMY"
  max_concurrency_level  = 16
}
```

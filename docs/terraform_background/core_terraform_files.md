# Core Terraform Files

## 1. Overview

Strictly speaking, you only need the file `main.tf`. However, Terraform projects typically use a set of standard files to organize configuration. These files promote consistency, modularity, and maintainability. Below is an overview of four core Terraform files, their purposes, and examples of their typical contents.

---

### **File: `main.tf`**

#### Purpose:
The primary configuration file in a Terraform project.
This is where you define the resources to be created and managed.

#### Typical Contents:
- Definitions of Snowflake resources (e.g., databases, schemas, tables, roles, grants).
- Data sources for retrieving existing Snowflake configurations.
- Modules for reusable blocks of configuration.
- Provisioners (rarely used in Snowflake projects but available if needed).

#### Example:
```hcl
resource "snowflake_database" "example" {
  name    = "EXAMPLE_DATABASE"
  comment = "This is an example database."
}

resource "snowflake_schema" "example" {
  database = snowflake_database.example.name
  name     = "EXAMPLE_SCHEMA"
}
```

---

### **File: `outputs.tf`**

#### Purpose:
Defines output values to share information about deployed infrastructure.
Outputs help with visibility and can pass data between modules.

#### Typical Contents:
- Outputs displaying data like database names, roles, or warehouse sizes.
- Outputs for referencing resource information in other modules or viewing deployment results.

#### Example:
```hcl
output "database_name" {
  description = "The name of the created Snowflake database"
  value       = snowflake_database.example.name
}

output "schema_name" {
  description = "The name of the created Snowflake schema"
  value       = snowflake_schema.example.name
}
```

---

### **File: `provider.tf`**

#### Purpose:
Specifies the provider(s) Terraform will use to manage resources.
Providers are plugins that allow Terraform to interact with specific platforms or services.

#### Typical Contents:
- Provider configuration blocks, including details like credentials and regions.
- Environment variables (e.g., `TF_VAR_snowflake_user`) for sensitive information such as account, username, and password.

#### Example:
```hcl
provider "snowflake" {
  account  = var.snowflake_account
  username = var.snowflake_user
  password = var.snowflake_password
  region   = var.snowflake_region
}
```

---

### **File: `variables.tf`**

#### Purpose:
Declares input variables, making the configuration more flexible and reusable.
Variables allow you to control settings without directly modifying the main configuration.

#### Typical Contents:
- Variable blocks defining database parameters, credentials, and settings.
- Enhances modularity and reusability of Terraform configurations.

#### Example:
```hcl
variable "snowflake_account" {
  description = "The Snowflake account name"
  type        = string
}

variable "snowflake_user" {
  description = "The Snowflake username"
  type        = string
}

variable "snowflake_region" {
  description = "The region for Snowflake instance"
  type        = string
  default     = "us-west-2"
}
```

---

## 2. Why Use These Files?

Although not mandatory, using these files is highly recommended for structuring Terraform projects.
A well-organized configuration:
- Simplifies ongoing management.
- Reduces errors.
- Makes it easier to update or extend Snowflake infrastructure as needs evolve.

---

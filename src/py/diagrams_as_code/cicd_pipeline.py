from diagrams import Cluster, Diagram

# from diagrams.aws.storage import S3
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.iac import Terraform
from diagrams.programming.language import Bash
from diagrams.saas.analytics import Snowflake

envs = ["ENV"]

# Generate Pull Request Pipeline Diagram
with Diagram("Snowflake Terraform CI/CD - PR Pipeline", show=False, direction="LR", filename="pr_pipeline"):
    with Cluster("PR Pipeline"):
        pr_trigger = GithubActions("PR Opened")

        for env in envs:
            with Cluster(f"{env}"):
                validate = Terraform("terraform\nvalidate")
                plan = Terraform("terraform\nplan")
                pr_trigger >> validate >> plan

# Generate Merge Pipeline Diagram
with Diagram("Snowflake Terraform CI/CD - Merge Pipeline", show=False, direction="LR", filename="merge_pipeline"):
    with Cluster("Code Deployment Pipeline"):
        merge_trigger = GithubActions("Code Merged")

        for env in envs:
            with Cluster(f"{env}"):
                plan = Terraform("terraform\nplan")
                apply = Terraform("terraform\napply")
                snowflake = Snowflake("Deploy\nSnowflake Changes")
                # state = S3("Push TF state\nfile")
                state = Bash("Push TF state\nfile")

                merge_trigger >> plan >> apply >> snowflake >> state

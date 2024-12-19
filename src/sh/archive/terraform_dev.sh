ENVIRONMENTS=("default" "DEV" "UAT" "CICD" "PROD")

cd v2_terraform

# Load variables from the .env file into the environment
export $(grep -v '^#' ../.env | xargs)

echo "1. Run command: 'terraform init'"
terraform init

echo "3. Run command: 'terraform plan -out=tfplan -input=false'"
terraform plan -out=tfplan -input=false

# echo "4. Run command: 'terraform apply -auto-approve tfplan'"
# terraform apply -auto-approve tfplan

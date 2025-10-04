# tf-select
![Go Version](https://img.shields.io/badge/Go-1.20+-blue)
![Terraform](https://img.shields.io/badge/Terraform-Compatible-5C4EE5?logo=terraform)
![Terragrunt](https://img.shields.io/badge/Terragrunt-Compatible-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
`tf-select` is a lightweight CLI tool that makes it easy to **select and apply specific T
---
## Features
- Works with **Terraform** and **Terragrunt** automatically.
- Lists all resources with their **index and action type** (create, update, delete).
- Apply specific resources via **index-based selection**.
- Automatically saves resource mappings for easy subsequent applies.
---
## ⚙️ Installation
### Via Go
go install github.com/yourusername/tf-select@latest
### Manual Build
git clone https://github.com/yourusername/tf-select.git
cd tf-select
go build -o tf-select
Add the binary to your `$PATH` if not already.
dont give me all this give me single file i can
download
---
## Commands
### `tf-select plan`
Runs a Terraform or Terragrunt plan, parses the JSON output, and lists all resources with
**Usage:**
tf-select plan
**Sample Output:**
Running terraform plan...
Resources detected:
aws_instance.web_server (create)
aws_security_group.web_sg (update)
aws_s3_bucket.logs (delete)
aws_iam_role.app_role (create)
✅ Mapping saved to .tf-select-cache.json
This command also stores an index → resource mapping in `.tf-select-cache.json`:
{
"1": "aws_instance.web_server",
"2": "aws_security_group.web_sg",
"3": "aws_s3_bucket.logs",
"4": "aws_iam_role.app_role"
}
---
### ⚡ `tf-select apply [indexes]`
Applies selected Terraform or Terragrunt resources based on the cached indexes.
**Usage Examples:**
- Apply specific resources:
tf-select apply 1 3
or comma-separated:
tf-select apply 1,3
- Apply *all* resources:
tf-select apply
**Sample Output:**
Running terraform: apply -target=aws_instance.web_server -target=aws_s3_bucket.logs
Terraform will perform the following actions:
Plan: 1 to add, 0 to change, 1 to destroy.
Do you want to perform these actions? Enter a value: yes
Apply complete! Resources: 1 added, 1 destroyed.
✅ Apply completed successfully.
If you pass an invalid index, output will be:
⚠️ Index 9 not found
---
## How It Works
1. `tf-select plan`:
- Runs `terraform plan -out=tfplan.binary`
- Converts the plan to JSON and extracts all resource addresses with actions.
- Saves the resource index mapping.
aws_instance.web_server will be created
resource ...
aws_s3_bucket.logs will be deleted
resource ...
2. `tf-select apply [indexes]`:
- Reads `.tf-select-cache.json`
- Builds the corresponding `terraform apply -target=` or `terragrunt apply -target=` c
- Executes directly with standard input/output streams.
3. It automatically detects **Terraform** or **Terragrunt** by checking for a `terragrunt
---
## Example Workflow
tf-select plan
tf-select apply 1 3
tf-select apply
---
## Files Generated
| File | Description |
|-----------------------|-----------------------------------------------|
| `tfplan.binary` | Terraform-generated plan file |
| `.tf-select-cache.json` | JSON file storing index-resource mappings |
---
## Requirements
- Go 1.20+
- Terraform or Terragrunt installed
- Valid Terraform configuration in current directory
---
## Example Output Recap
| Command | Description | Example Output (short) |
|----------|--------------|------------------------|
| `tf-select plan` | Lists resource changes | `[1] aws_instance.web (create)` |
| `tf-select apply 1` | Applies resource by index | ` Running terraform apply -target=aw
| `tf-select apply` | Applies all resources | `✅ Apply completed successfully.` |
Step 1: Generate plan and view resource indexes
Step 2: Apply only specific indexes
Step 3: Apply all listed resources
---
## License
Distributed under the **MIT License**.
Copyright © 2025
---
### Author
**Your Name**
DevOps Engineer • Infra Automation Enthusiast
you@example.com
[GitHub](https://github.com/yourusername)
---
This is a complete single file ready to use.
Just rename it to README.md in your project root.
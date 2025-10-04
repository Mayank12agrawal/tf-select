# 🌱 tf-select

![Go Version](https://img.shields.io/badge/Go-1.20+-blue)
![Terraform](https://img.shields.io/badge/Terraform-Compatible-5C4EE5?logo=terraform)
![Terragrunt](https://img.shields.io/badge/Terragrunt-Compatible-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

`tf-select` is a lightweight CLI tool that makes it easy to **select and apply specific Terraform or Terragrunt resources by index**, avoiding the need to type long resource names.

---

## 🚀 Features

- Works automatically with both **Terraform** and **Terragrunt**.
- Lists all resources in a plan, showing their **index and planned action** (create, update, delete).
- Apply specific resources by referring to their **index-based selection**.
- Automatically saves resource-to-index mappings for easy targeted apply operations.

---

## ⚙️ Installation

### Via Go

go install github.com/yourusername/tf-select@latest

### Manual Build
git clone https://github.com/yourusername/tf-select.git
cd tf-select
go build -o tf-select


Make sure the binary is in your `$PATH` for easy execution.

---

## 🧩 Commands

### 🔍 `tf-select plan`

Runs a Terraform or Terragrunt plan, parses the JSON output, and lists all resources with their corresponding indexes.

**Usage:**

tf-select plan

**Sample Output:**
🔍 Running terraform plan...

📋 Resources detected:
aws_instance.web_server (create)
aws_security_group.web_sg (update)
aws_s3_bucket.logs (delete)
aws_iam_role.app_role (create)

✅ Mapping saved to .tf-select-cache.json

This command saves the index-to-resource mapping in `.tf-select-cache.json`:
{
"1": "aws_instance.web_server",
"2": "aws_security_group.web_sg",
"3": "aws_s3_bucket.logs",
"4": "aws_iam_role.app_role"
}


---

### ⚡ `tf-select apply [indexes]`

Applies the selected Terraform or Terragrunt resources based on the saved indexes.

**Usage Examples:**

- Apply specific resources by index:

tf-select apply 1 3

or using comma-separated indexes:

tf-select apply 1,3

- Apply *all* resources listed in the plan:

tf-select apply

**Sample Output:**

🚀 Running terraform: apply -target=aws_instance.web_server -target=aws_s3_bucket.logs

Terraform will perform the following actions:

aws_instance.web_server will be created
resource ...

aws_s3_bucket.logs will be deleted
resource ...

Plan: 1 to add, 0 to change, 1 to destroy.
Do you want to perform these actions? Enter a value: yes

Apply complete! Resources: 1 added, 1 destroyed.
✅ Apply completed successfully.


If you specify an invalid index, you will see:

⚠️ Index 9 not found

---

## 🔍 How It Works

1. `tf-select plan`:
   - Runs `terraform plan -out=tfplan.binary`.
   - Converts the plan to JSON and extracts resource addresses and planned actions.
   - Saves an index-to-resource mapping.

2. `tf-select apply [indexes]`:
   - Reads `.tf-select-cache.json`.
   - Constructs the appropriate `terraform apply -target=` (or `terragrunt apply -target=`) commands.
   - Executes them, keeping standard input/output interactive.

3. Automatically detects if you are using **Terraform** or **Terragrunt** by checking for a `terragrunt.hcl` file in the directory.

---

## 🧾 Example Workflow

Generate the plan and list resources
tf-select plan

Apply specific resources by index
tf-select apply 1 3

Apply all resources from the last plan
tf-select apply

---

## 📂 Generated Files

| File                   | Description                          |
|------------------------|------------------------------------|
| `tfplan.binary`        | The Terraform plan output file.    |
| `.tf-select-cache.json` | JSON file mapping indexes to resources. |

---

## 🛠 Requirements

- Go version 1.20 or newer
- Terraform or Terragrunt installed and configured
- A valid Terraform or Terragrunt configuration in the working directory

---

## ⚡ Example Output Summary

| Command             | Description             | Sample Output (abridged)              |
|---------------------|-------------------------|-------------------------------------|
| `tf-select plan`    | List resource changes    | `[1] aws_instance.web (create)`      |
| `tf-select apply 1` | Apply resource by index  | `Running terraform apply -target=aws_instance.web` |
| `tf-select apply`   | Apply all resources      | `✅ Apply completed successfully.`   |

---

## 📜 License

Released under the **MIT License** © 2025.

---

## ✍️ Author

**Your Name**  
DevOps Engineer & Infrastructure Automation Enthusiast  
✉️ you@example.com  
🔗 [GitHub Profile](https://github.com/yourusername)

---

*Save this file as* `README.md` *in your project root directory.*






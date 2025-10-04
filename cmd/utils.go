package cmd

import "os"

func getTfCmd() string {
	if _, err := os.Stat("terragrunt.hcl"); err == nil {
		return "terragrunt"
	}
	return "terraform"
}

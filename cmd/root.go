package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "tf-select",
	Short: "Select specific Terraform/Terragrunt resources to apply",
	Long:  `tf-select helps you list resources and apply them by index instead of typing long resource names.`,
}

func Execute() {
	rootCmd.AddCommand(planCmd)
	rootCmd.AddCommand(applyCmd)
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

package cmd

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/spf13/cobra"
)

var applyCmd = &cobra.Command{
	Use:   "apply [indexes]",
	Short: "Apply selected terraform/terragrunt resources by index",
	Args:  cobra.MinimumNArgs(0), // allow 0 or more args
	Run: func(cmd *cobra.Command, args []string) {
		tfCmd := getTfCmd()

		data, err := os.ReadFile(".tf-select-cache.json")
		if err != nil {
			fmt.Println("❌ Run 'tf-select plan' first.")
			os.Exit(1)
		}

		var mapping map[string]string
		json.Unmarshal(data, &mapping)

		var targets []string

		if len(args) == 0 {
			// Apply all
			for _, res := range mapping {
				targets = append(targets, fmt.Sprintf("-target=%s", res))
			}
		} else {
			for _, arg := range args {
				indices := strings.Split(arg, ",")
				for _, idx := range indices {
					idx = strings.TrimSpace(idx)
					if res, ok := mapping[idx]; ok {
						targets = append(targets, fmt.Sprintf("-target=%s", res))
					} else {
						fmt.Printf("⚠️ Index %s not found\n", idx)
						os.Exit(1)
					}
				}
			}
		}

		if len(targets) == 0 {
			fmt.Println("❌ No valid targets selected.")
			os.Exit(1)
		}

		argsToRun := append([]string{"apply"}, targets...)
		fmt.Printf("🚀 Running %s: %s\n", tfCmd, strings.Join(argsToRun, " "))
		cmdExec := exec.Command(tfCmd, argsToRun...)
		cmdExec.Stdout = os.Stdout
		cmdExec.Stderr = os.Stderr
		cmdExec.Stdin = os.Stdin

		if err := cmdExec.Run(); err != nil {
			fmt.Printf("❌ %s apply failed: %v\n", tfCmd, err)
			os.Exit(1)
		}

		fmt.Println("✅ Apply completed successfully.")
	},
}

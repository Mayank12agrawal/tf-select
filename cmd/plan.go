package cmd

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strconv"

	"github.com/spf13/cobra"
)

var planCmd = &cobra.Command{
	Use:   "plan",
	Short: "Run terraform/terragrunt plan and list resources with action",
	Run: func(cmd *cobra.Command, args []string) {
		tfCmd := getTfCmd()
		planFile := "tfplan.binary"

		fmt.Printf("🔍 Running %s plan...\n", tfCmd)

		// Run plan and save to file
		cmdExec := exec.Command(tfCmd, "plan", "-out="+planFile)
		cmdExec.Stdout = os.Stdout
		cmdExec.Stderr = os.Stderr
		cmdExec.Stdin = os.Stdin
		if err := cmdExec.Run(); err != nil {
			fmt.Printf("❌ %s plan failed: %v\n", tfCmd, err)
			os.Exit(1)
		}

		// Parse JSON from plan file
		jsonOut, err := exec.Command(tfCmd, "show", "-json", planFile).Output()
		if err != nil {
			fmt.Println("❌ Failed to parse plan JSON:", err)
			os.Exit(1)
		}

		var planData map[string]interface{}
		if err := json.Unmarshal(jsonOut, &planData); err != nil {
			fmt.Println("❌ Failed to unmarshal plan JSON:", err)
			os.Exit(1)
		}

		mapping := make(map[string]string)
		counter := 1

		// Use resource_changes to get action (create/update/delete)
		if rcList, ok := planData["resource_changes"].([]interface{}); ok {
			fmt.Println("\n📋 Resources detected:")
			for _, rc := range rcList {
				rcMap := rc.(map[string]interface{})
				addr := rcMap["address"].(string)

				action := "unknown"
				if changes, ok := rcMap["change"].(map[string]interface{}); ok {
					if actions, ok := changes["actions"].([]interface{}); ok && len(actions) > 0 {
						action = actions[0].(string)
					}
				}

				fmt.Printf("[%d] %s (%s)\n", counter, addr, action)
				mapping[strconv.Itoa(counter)] = addr
				counter++
			}
		}

		// Save mapping
		data, _ := json.MarshalIndent(mapping, "", "  ")
		os.WriteFile(".tf-select-cache.json", data, 0644)
		fmt.Println("\n✅ Mapping saved to .tf-select-cache.json")
	},
}

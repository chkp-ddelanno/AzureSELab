variable "project_name" {
  description = "Project Name - will prefex all generated resource names"
  default     = "SE-LAB"
}

variable "region" {
  default = "Canada Central"
}


# SIC key
variable "sic_key" {
  description = "One time password used to established connection between the Management and the Security Gateway"
  default     = "1q2w3e4r"
}

variable "cpversion" {
  description = "Check Point version"
  default     = "R8040"
}

variable "management_server_size" {
  default = "Standard_D2_v3"
}


variable "my_custom_data" {
  # Adjust as needed
  default = <<-EOF
                #!/bin/bash
                clish -c 'set user admin shell /bin/bash' -s
                config_system -s 'install_security_gw=false&install_ppak=false&gateway_cluster_member=false&install_security_managment=true&install_mgmt_primary=true&install_mgmt_secondary=false&download_info=true&hostname=R80dot40mgmt&mgmt_gui_clients_radio=any&mgmt_admin_radio=gaia_admin'
                /opt/CPvsec-R80.40/bin/cloudguard on
                while true; do
                status=`api status |grep 'API readiness test SUCCESSFUL. The server is up and ready to receive connections' |wc -l`
                echo "Checking if the API is ready"
                if [[ ! $status == 0 ]]; then
                   break
                fi
                   sleep 15 
                done
                echo "API ready " `date`
                sleep 5
                echo "Set R80 API to accept all ip addresses"
                mgmt_cli -r true set api-settings accepted-api-calls-from "All IP addresses" --domain 'System Data'
                echo "Add user api_user with password Cpwins1!"
                mgmt_cli -r true add administrator name "api_user" password "Cpwins1!" must-change-password false authentication-method "INTERNAL_PASSWORD" permissions-profile "Super User" --domain 'System Data'
                echo "Restarting API Server"
                api restart
                EOF
}


# TruckCo Logistics Portal - Infrastructure as Code


## 🔐 Prerequisites
1. **Terraform**
2. **Ansible**
3. **Azure CLI**

## 🚀 Setup Steps

### Step 1: Azure Authentication

```bash
az login
# Select your subscription if you have multiple
az account set --subscription "<SUBSCRIPTION_ID>"
```

### Step 2: Configure Terraform Variables

1. Copy the example file:
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Update the variables in `terraform.tfvars`:
   ```hcl
   resource_group_name = "truck-rg"
   location             = "eastus"
   ssh_ip               = "YOUR_PUBLIC_IP/32"    # Example: "203.0.113.45/32"
   admin_username       = "azureuser"
   ssh_key              = file("~/.ssh/id_rsa.pub")
   ```

### Step 3: Initialize Terraform

```bash
terraform init
```

### Step 4: Full Deployment (Infrastructure + Configuration)

```bash
cd terraform
terraform plan -out=tfplan
terraform apply tfplan

cd ../ansible
ansible-playbook -i hosts.ini playbook.yml

curl http://<PUBLIC_IP>
```

### Individual Steps

#### Infrastructure Only (Terraform)
```bash
cd terraform
terraform apply -var-file=terraform.tfvars
```

#### Configuration Only (Ansible)
Ensure `ansible/hosts.ini` exists with VM IP, then:
```bash
cd ansible
ansible-playbook -i hosts.ini playbook.yml
```

### Key Design Decisions

#### 1. **Modular Terraform Structure**
- **Why:** Separation of concerns makes code maintainable and reusable
- **Implementation:** 
  - `modules/network/` - VNet and subnet management
  - `modules/security/` - NSG and firewall rules
  - `modules/vm/` - VM and network interface configuration
- **Benefit:** Easy to expand for additional VMs or networking changes

#### 2. **Single Resource Group**
- **Why:** Simplifies management and billing; easy to delete entire deployment
- **Trade-off:** In production, you might use separate RGs for different environments

#### 3. **Network Security Group (NSG)**
- **Why:** Layer 4 network-level security before VM-level firewall
- **Features:**
  - SSH restricted to local IP (prevents brute-force attacks)
  - HTTP open to internet (required for web service)
  - Explicit deny-all default rule at low priority

#### 4. **Premium_LRS for OS Disk**
- **Why:** Reliability and performance, even for small VMs
- **Cost:** Slightly higher but includes SLA guarantees
- **Size:** 30GB (default, sufficient for Nginx)

#### 5. **Static Public IP**
- **Why:** IP doesn't change if VM is stopped/deallocated
- **Cost:** Minimal additional cost
- **Requirement:** DNS records remain stable

#### 6. **Terraform Inventory Generation**
- **Why:** No manual inventory management; always in sync with infrastructure
- **Implementation:** `local_file` resource uses `templatefile()` to render `inventory.tpl`
- **Location:** Generated at `ansible/hosts.ini` automatically

#### 7. **Ansible Handlers for Service Restarts**
- **Why:** Ensures SSH and Nginx are properly restarted after config changes
- **Implementation:** `notify` directives trigger handlers only if tasks change state
- **Benefit:** Idempotent playbook - safe to run multiple times

#### 8. **Key-Based SSH Authentication Only**
- **Why:** Prevents password-based attacks
- **Implementation:** `PasswordAuthentication no` in sshd_config
- **Pre-requisite:** SSH public key must be added during VM creation

---

## Cleanup

To remove all deployed resources:

```bash
cd terraform
terraform destroy
```

## Variables Reference

### terraform.tfvars

| Variable | Type | Example | Required |
|----------|------|---------|----------|
| `resource_group_name` | string | `truck-rg` | Yes |
| `location` | string | `eastus` | Yes |
| `ssh_ip` | string | `203.0.113.45/32` | Yes |
| `admin_username` | string | `azureuser` | Yes |
| `ssh_key` | string | `file("~/.ssh/id_rsa.pub")` | Yes |

### Environment Variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `ARM_CLIENT_ID` | Service principal client ID | Service Principal auth |
| `ARM_CLIENT_SECRET` | Service principal password | Service Principal auth |
| `ARM_SUBSCRIPTION_ID` | Azure subscription ID | Service Principal auth |
| `ARM_TENANT_ID` | Azure tenant ID | Service Principal auth |

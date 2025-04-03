# OpenTofu Incus Infrastructure

This repository contains OpenTofu configurations for managing Incus infrastructure across multiple sites. Each site can be either a clustered environment (like clubcotton) or a single machine setup (like condo and natalya).

## Repository Structure

```
./
├── modules/
│   ├── networking/    # Network, ACL, forwarding, and load balancer configurations
│   ├── profiles/      # Shared profile definitions
│   └── storage/       # Storage pool and volume configurations
└── sites/
    ├── clubcotton/    # Clustered environment
    │   ├── dev/       # Development environment
    │   └── prod/      # Production environment
    ├── condo/         # Single machine environment
    │   ├── dev/
    │   └── prod/
    └── natalya/       # Single machine environment
        ├── dev/
        └── prod/
```

## Prerequisites

- OpenTofu installed
- Incus installed and configured
- Environment variables set:
  ```bash
  export INCUS_SOCKET_PATH=...  # or INCUS_REMOTE
  export INCUS_CLIENT_CERT=...
  export INCUS_CLIENT_KEY=...
  export INCUS_SERVER_CERT=...
  export INCUS_PROJECT=...
  ```

## Common Tasks

### Initial Setup

1. Clone the repository
2. Navigate to the desired site and environment:
   ```bash
   cd sites/condo/dev
   ```
3. Initialize OpenTofu:
   ```bash
   tofu init
   ```

### Managing State

- Create/update resources:
  ```bash
  tofu plan    # Review changes
  tofu apply   # Apply changes
  ```
- Destroy resources:
  ```bash
  tofu destroy
  ```
- View current state:
  ```bash
  tofu show
  ```
- Refresh state:
  ```bash
  tofu refresh
  ```

### Managing Individual Resources

#### Targeting Specific Resources

You can target specific resources for apply or destroy operations using the `-target` flag:

- Apply a single resource:
  ```bash
  # Format: tofu apply -target=resource_type.resource_name
  tofu plan -target=incus_instance.homeassistant    # Review changes
  tofu apply -target=incus_instance.homeassistant   # Apply changes
  ```

- Destroy a single resource:
  ```bash
  # Format: tofu destroy -target=resource_type.resource_name
  tofu plan -destroy -target=incus_instance.homeassistant    # Review destruction
  tofu destroy -target=incus_instance.homeassistant          # Destroy resource
  ```

- Target a specific module:
  ```bash
  # Format: tofu apply -target=module.module_name
  tofu apply -target=module.profiles    # Apply all resources in the profiles module
  ```

- Target a resource within a module:
  ```bash
  # Format: tofu apply -target=module.module_name.resource_type.resource_name
  tofu apply -target=module.profiles.incus_profile.base
  ```

#### Taint/Untaint Resources

If you need to recreate a resource:

1. Mark resource for recreation:
   ```bash
   tofu taint incus_instance.homeassistant
   ```

2. Remove taint if needed:
   ```bash
   tofu untaint incus_instance.homeassistant
   ```

3. Apply changes:
   ```bash
   tofu plan    # Review recreation plan
   tofu apply   # Recreate resource
   ```

### Adding New Instances

#### Adding a VM Instance

1. In your environment's `instances.tf`, add a new resource block:
   ```hcl
   resource "incus_instance" "new_vm" {
     name      = "${var.environment}-vm-name"
     image     = "image-name"
     type      = "virtual-machine"
     profiles  = [module.profiles.vm_profile_name]
     project   = "default"

     device {
       name = "eth0"
       type = "nic"
       properties = {
         nictype = "bridged"
         parent  = var.network_bridge
       }
     }

     device {
       name = "root"
       type = "disk"
       properties = {
         pool = var.storage_pool
         path = "/"
         size = var.storage_sizes["vm"]
       }
     }
   }
   ```

2. Add any necessary variables to `variables.tf`
3. Update `outputs.tf` to include the new instance

#### Adding a Container Instance

1. In your environment's `instances.tf`, add a new resource block:
   ```hcl
   resource "incus_instance" "new_container" {
     name      = "${var.environment}-container-name"
     image     = "images:ubuntu/jammy"
     type      = "container"
     profiles  = [module.profiles.container_profile_name]
     project   = "default"

     device {
       name = "eth0"
       type = "nic"
       properties = {
         nictype = "bridged"
         parent  = var.network_bridge
       }
     }

     device {
       name = "root"
       type = "disk"
       properties = {
         pool = var.storage_pool
         path = "/"
         size = var.storage_sizes["container"]
       }
     }
   }
   ```

2. Add any necessary variables to `variables.tf`
3. Update `outputs.tf` to include the new instance

### Maintenance Tasks

#### Updating Images

1. Pull the latest image:
   ```bash
   incus image copy images:ubuntu/jammy local: --alias ubuntu/jammy
   ```

2. Update the image reference in your instance configuration if needed

#### Managing Profiles

1. Profiles are managed through the profiles module
2. To add a new profile:
   - Add profile definition in `modules/profiles/main.tf`
   - Add output in `modules/profiles/outputs.tf`
   - Reference the profile in your instance configurations

#### Backup Management

Currently, snapshot management is postponed due to technical limitations. Alternative backup strategies:

1. Export instance backup:
   ```bash
   incus export instance-name backup-name.tar.gz
   ```

2. Manual filesystem backup of the storage pool

#### Resource Scaling

To adjust instance resources:

1. Update the relevant variables in `variables.tf`:
   ```hcl
   variable "vm_config" {
     default = {
       "limits.cpu"    = "4"
       "limits.memory" = "8GB"
     }
   }
   ```

2. Apply the changes:
   ```bash
   tofu plan
   tofu apply
   ```

## Troubleshooting

### Common Issues

1. Instance fails to start:
   - Check instance logs: `incus info instance-name`
   - Verify resource availability
   - Check network bridge status

2. Network connectivity issues:
   - Verify bridge configuration
   - Check host network interface status
   - Verify DHCP service is running

3. Storage issues:
   - Check storage pool status: `incus storage list`
   - Verify available space
   - Check storage pool permissions

### Getting Help

- Check instance logs: `incus info <instance>`
- View OpenTofu debug output: `TF_LOG=DEBUG tofu plan`
- Verify Incus daemon status: `systemctl status incus`
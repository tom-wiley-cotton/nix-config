# Incus Infrastructure Management Plan

## Project Structure ✓
```
./
├── modules/
│   ├── networking/    # Network, ACL, forwarding, and load balancer configurations
│   ├── profiles/      # Shared profile definitions
│   └── storage/       # Storage pool and volume configurations
└── sites/
    ├── clubcotton/    # Clustered environment
    │   ├── dev/       # Development environment
    │   │   ├── main.tf        # Module usage
    │   │   ├── instances.tf   # Environment-specific instances
    │   │   ├── variables.tf   # Environment variables
    │   │   └── outputs.tf     # Environment outputs
    │   └── prod/      # Production environment
    │       ├── main.tf        # Module usage
    │       ├── instances.tf   # Environment-specific instances
    │       ├── variables.tf   # Environment variables
    │       └── outputs.tf     # Environment outputs
    ├── condo/         # Single machine environment
    │   ├── dev/
    │   └── prod/
    └── natalya/       # Single machine environment
        ├── dev/
        └── prod/
```

## Implementation Plan

### Phase 1: Project Setup ✓
- [x] Define project structure
- [x] Create base provider configuration
- [x] Set up workspaces for dev/prod environments
- [x] Configure backend for state management

### Phase 2: Clubcotton Implementation (Priority)
#### Infrastructure Details
- Cluster: 3 nodes (all running all services, managed outside of Terraform)
- Networking: Single bridge network 'br0' (pre-existing)
- Storage: Using existing ZFS pool "local"
- Instances: Mix of Ubuntu-based VMs and containers
- Profiles: Custom profiles based on workload requirements

#### Implementation Steps
- [x] Base Configuration
  - [x] Provider setup
  - [x] Network integration with existing 'br0'
  - [x] Using existing ZFS pool "local"
- [x] Profile Configuration
  - [x] Create base profile
  - [x] Create VM profile
  - [x] Create container profile
  - [x] Create Home Assistant profile with stateful migration
- [x] Dev Environment Setup
  - [x] Create dev profiles with "dev-" prefix
  - [x] Deploy test container (192.168.5.69)
  - [x] Deploy Home Assistant VM (192.168.5.90)
  - [x] Deploy Home Assistant macvlan VM (192.168.5.91)
- [x] Prod Environment Setup
  - [x] Create prod profiles with "prod-" prefix
  - [x] Deploy production Home Assistant VM (192.168.5.93)
  - [x] Higher resource allocations than dev
- [x] Code Organization
  - [x] Move instance definitions to environment-specific files
  - [x] Remove unused instances module
  - [x] Update environment configurations
- [ ] Backup and Maintenance
  - [ ] Snapshot configuration (postponed due to technical limitations)
  - [ ] Alternative backup strategy needed

### Phase 3: Condo and Natalya Implementation
- [ ] Adapt clubcotton structure for single-machine setup
- [ ] Implement condo configuration
- [ ] Implement natalya configuration

## Resource Implementation Order
1. ✓ Network integration (using existing br0)
2. ✓ Storage pool (using existing local pool)
3. ✓ Profiles (base, vm-base, container-base, haos)
4. ✓ Instances (per environment)
   - [x] Dev instances created successfully
   - [x] Prod instances created successfully
5. [ ] Backup strategy (needs revision)

## Notes
- Each site maintains separate state files
- Starting with clubcotton as primary implementation
- Using environment-specific instance definitions for better control
- Will verify each step with 'tofu' commands
- Using incus provider version 0.3.0
- Cluster management is outside of Terraform scope
- Custom profiles have been created based on specific workload requirements
- Snapshot configuration postponed due to technical limitations

## Next Steps
1. Begin implementation of condo site
2. Research alternative backup strategies
3. Plan natalya site implementation

Would you like to proceed with setting up the condo site using this improved structure?
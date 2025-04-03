I would like to create a terraform/opentofu project to manage some incus/lcx projects using the incus terraform provider:

from @https://library.tf/providers/lxc/incus/latest
```
terraform {
  required_providers {
    incus = {
      source = "lxc/incus"
      version = "0.3.0"
    }
  }
}

provider incus {
  # Configuration options
}
```

for this project I will be managing at least three installations of incus in seperate physical locations, but they will all have access to this directory structure. So the state files will be completely separate. 

The sites are: 
- clubcotton
- condo
- natalya

The 'clubcotton' config uses incus clustering and will run a variety of vms and containers.

The other configs are single machine, and will run a smaller subset of vms and containers.

each of the sites should have a 'dev' and 'prod' environment/workspace config.

We will build out clubcotton first, then move on the the other environments.

We will be using many of the resource types defined in the incus provider:
- incus_​certificate
- incus_​cluster_​group
- incus_​cluster_​group_​assignment
- incus_​image
- incus_​instance
- incus_​instance_​snapshot
- incus_​network
- incus_​network_​acl
- incus_​network_​forward
- incus_​network_​integration
- incus_​network_​load_​balancer
- incus_​profile
- incus_​storage_​pool
- incus_​storage_​volume

We will layer in each of the resources, one at a time, and you will ask me for a link to the  documentation for each resource.

I know very little about terraform/opentofu, so I need you to guide me through the process of designing the terraform project.

Please ask me one question at a time until we have created a plan.

Write down that plan in a file called incus-plan.md. Keep a list of complete items, we will check them off as we go. Use this file to keep notes about what you have implemented.

Do not start coding until we have agreed on the plan.

Use best terraform practices, but there is no need to overcomplicate the config

use the command 'tofu' and 'incus' is installed. At any point you can check your work using 'tofu' or 'incus' you should run the correct command to verify with work so far, and correct any errors.


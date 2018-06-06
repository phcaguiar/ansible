Windows DFS Ansible Role Installer
=========

Ansible Role to install and configure Windows DFS

Task Options
--------------

**Mandatory**

`dfs_primary_server_name:` ## Hostanme to primary DFS Server. Ex: `mydfsserver01`<br/>
`dfs_nonprimary_server_name:` ## Hostname to nonprimary DFS Server. Ex: `mydfsserver02`. Use this option only domainv1 or domainv2 namespace.<br/>
`dfs_namespace_type:` ## DFS Type. Ex: `domainv1`, `domainv2` or `standalone`<br/>
`dfs_share_name:` ## Root Share to DFS. Ex: `MyShare`<br/>
`dfs_root_path:` ## Root Path to DFS. Ex: `C:\DFSRoot`<br/>

**Optional**

`dfs_replication_group_name` - Use this option to dfs replication group name. If no value is defined the value used will be the same as dfs_share_name.<br/>
`dfs_replicated_folder_name` - Use this option to dfs replicated folder name. If no value is defined the value used will be the same as dfs_share_name.<br/>
`enable_site_costing` - Boolean value. The default value is `$false`.<br/>
`enable_insite_referrals` - Boolean value. The default value is `$false`.<br/>
`enable_access_based_enumeration` - Boolean value. The default value is `$false`.<br/>
`enable_root_scalability` - Boolean value. The default value is `$false`.<br/>
`enable_target_failback` - Boolean value. The default value is `$false`.<br/>

Example Task
----------------

```yaml
---
- name: Task to deploy DFS
  win_dfs:
    dfs_primary_server_name: mydfsserver01
    dfs_nonprimary_server_name: mydfsserver02
    dfs_namespace_type: domainv2
    dfs_share_name: MyShare
    dfs_root_path: C:\DFSRoot
    enable_site_costing: $true
```

License
-------

MIT

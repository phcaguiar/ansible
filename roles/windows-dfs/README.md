![alt text](https://github.com/phcaguiar/ansible/tree/master/roles/windows-dfs/img/img.svg)

DFS 
=========

Install and deploy DFS

Requirements
------------

Use the winrm connection configuration with transport [CredSSP](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html#id16) and use two host groups called `[primary-dfs]` and `[non-primary-dfs]` and configure a variable file named dfs in the group_vars directory with the following variables:

`DEPLOY_DFS` - This variable should be True when the DFS servers configuration is performed.<br/>
`PROJECT_TEAM_PATH` - This variable should be set to True when the project's project directory is configured.

Role Variables
--------------

To execute this role it is necessary to fill in the variables file [main.yml](https://github.com/phcaguiar/ansible/blob/master/roles/windows-dfs/defaults/main.yml).

Directory Tree
----------------

```bash
.
├── defaults
│   └── main.yml
├── img
│   └── img.svg
├── meta
│   └── main.yml
├── README.md
├── tasks
│   ├── dfs-config.yml
│   ├── dfs-project-team-path.yml
│   ├── dfs-quota.yml
│   ├── dfs-share.yml
│   ├── install-features.yml
│   └── main.yml
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```

Example Playbook
----------------

```yaml
    - hosts: servers
      roles:
         - { role: windows-dfs }
```

License
-------

MIT

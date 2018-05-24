![alt text](https://github.com/phcaguiar/ansible/tree/master/roles/appdynamics-agent/img/logo.svg)

AppDynamics Installer
=========

Install a AppDynamics Agent to a Windows and Linux Host

Role Variables
--------------

### Dynamics Variable - Mandatory 

* **controller_host**: AppDynamics Host
* **application_name**:  AppDynamics Application Name
* **account_name**: AppDynamics Account Name
* **password**: AppDynamics Account Password
* **application_executable**: Application Executable 
* **tier_name**: Application Tier Name
* **application_service**: Application Windows Service
* **iis_automatic_enabled**: Enable or Disable IIS Automatic Discovery (Default is false)

Directory Tree
----------------

```bash
.
├── defaults
│   └── main.yml
├── README.md
├── tasks
│   ├── main.yml
│   └── windows
│       ├── copy-config-file.yml
│       ├── create-directory.yml
│       ├── delete-file.yml
│       ├── download-agent.yml
│       ├── install-agent.yml
│       ├── main.yml
│       └── restart-app.yml
└── templates
    └── config.xml.j2
```

Example Playbook to Install AppDynamics Agent
----------------

```yaml
- hosts: windows
  roles:
    - { role: appdynamics-agent }
```

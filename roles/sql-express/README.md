SQL Express Installer
=========

Ansible Role to install SQL Express

Role Variables
--------------

Use the following variables:<br/>

`sql_instance_name` - Use to SQL Instance Name<br/>
`sql_svc_account` - Use to SQL Service Account<br/>
`sql_svc_password` - Use to SQL Service Password<br/>

Note: These variables are mandatory.

Example Playbook
----------------

```yaml
- hosts: all
  roles:
    - sql-express

## For Install SQL Express     
  vars_prompt:
    - name: sql_instance_name
      prompt: Enter SQL Instance Name
      private: no
    - name: sql_svc_account
      prompt: Enter SQL Service Account Name
      private: no
    - name: sql_svc_password
      prompt: Enter SQL Service Account Password
      private: yes
```

License
-------

MIT

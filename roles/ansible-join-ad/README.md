# Join Active Directory

Role to enroll and leave a server Microsoft Active Directory.

## Requirements

To install requirements you can run this command: `pip install -r requirements.txt` 

## Role Variables
``` yaml
 - joinad_enrollment_user = "user"
 - joinad_enrollment_password = "password"
 - joinad_domain_controller_ip = "x.x.x.x"
```

 **Others variables can come from common-linux role or be reported as extra-vars. For this, can you see [`defaults/main.yml`](defaults/main.yml).**

## Dependencies
Not yet.

## Example Playbook

```yaml
- hosts: all
  become: true
  vars:
    joinad_domain_controller_ip: ""
    joinad_dns_server: ""
    joinad_dns_domain: ""
    joinad_enrollment_user: null
    joinad_enrollment_password: null
  roles:
    - role: join-ad
```

## Testing
This role implements unit tests with Molecule and Vagrant. Notice that we only support Molecule 2.0 or greater. You can install molecule with:

```shell
pip install molecule
```

After having Molecule setup, you can run the tests with:

```
molecule test
```

## Usefull Links
 - [kinit](https://kb.iu.edu/d/aumh)
 - [realmd](https://www.freedesktop.org/software/realmd/docs/)
 - [adcli](https://www.freedesktop.org/software/realmd/adcli/adcli.html)
 - [kerberos](https://web.mit.edu/kerberos/)
 - [sssd](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/SSSD-Introduction.html)

## License
MIT

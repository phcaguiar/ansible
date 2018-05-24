Windows VSTS Agent
=========

Install a vsts agent to a windows host.  
This role supports both `deployment group agent` and `regular queue agent`.  
Read more about VSTS agents [here](https://docs.microsoft.com/en-us/vsts/build-release/concepts/agents/agents).

Role Variables
--------------

### Mandatory

* **VSTS_ACCOUNT_NAME**: Your VSTS account name. The name before `visualstudio.com` in your access url.
* **AUTH_TOKEN**: Your personal access token to register the agent.
* **PROJECT_NAME**: The VSTS Team Project to register the agent.

#### For deployment agent

* **DEPLOYMENT_GROUP_NAME**: The Deployment Group to register the agent.

#### For queue/build agent

* **AGENT_POOL**: The Agent Pool to register the agent.

### Optional

* **AGENT_FOLDER**: The agent installation folder. Default is `C:\vstsagent`.
* **AGENT_DOWNLOAD_URL**: The url to download the agent zip. Default to Microsoft official link.
* **AGENT_NAME**: Name used to register the agent. Default is the host name retrivied by the ansible fact `ansible_hostname`.
* **DEPLOYMENT_GROUP_TAGS**: Optional agent tags.
* **WINDOWS_ACCOUNT**: To use specific user account to run the service. Default is "NT AUTHORITY/SYSTEM".
* **WINDOWS_PASS_ACCOUNT**: Password to use with specific user account.
* **PROXY_URL**: Optional configuration to connect agent through http proxy.
* **PROXY_USERNAME**: Proxy user.
* **PROXY_PASS**: Proxy user password.
* **PROXYBYPASS**: IP Addresses for proxybypass file. Multiple Addresses must be separated by comma ','.
    * In the proxybypass file is compulsory to use the "\\" character before the "." character at the recommendation of Microsoft, pursuant to the link [Microsoft Recommendations](https://docs.microsoft.com/en-us/vsts/build-release/actions/agents/proxy?view=vsts)

Example Playbook to install deployment agent
----------------

```yaml
- hosts: windows
  vars:
    VSTS_ACCOUNT_NAME: myorg # For https://myorg.visualstudio.com
    PROJECT_NAME: MyTeam
    DEPLOYMENT_GROUP_NAME: MyApp-Staging
  vars_prompt:
  - name: "AUTH_TOKEN"
    prompt: "Enter AUTH_TOKEN"
    private: yes
  roles:
    - { role: vsts-agent }
```

Example Playbook to install queue agent
----------------

```yaml
- hosts: windows
  vars:
    VSTS_ACCOUNT_NAME: myorg # For https://myorg.visualstudio.com
    PROJECT_NAME: MyTeam
    AGENT_POOL: WinBuilders
  vars_prompt:
  - name: "AUTH_TOKEN"
    prompt: "Enter AUTH_TOKEN"
    private: yes
  roles:
    - { role: vsts-agent }
```

Advanced scenarios
----------------

#### How to install multiple queue agents on the same machine (not supported for deployment group agents)

In your inventory add multiple entries for the same host with different values for AGENT_NAME and AGENT_FOLDER

```ini
[queue-agents]
HOST-01-1 ansible_host=10.0.0.10 AGENT_NAME=HOST-01-1 AGENT_FOLDER=C:\\vstsagent\\A1
HOST-01-2 ansible_host=10.0.0.10 AGENT_NAME=HOST-01-2 AGENT_FOLDER=C:\\vstsagent\\A2
...
```

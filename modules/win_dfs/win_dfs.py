#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright: (c) 2018, Pedro Aguiar (@phcaguiar) 
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

ANSIBLE_METADATA = {'metadata_version': '1.1',
                    'status': ['stableinterface'],
                    'supported_by': 'core'}

DOCUMENTATION = r'''
---
module: win_dfs
version_added: "1.0.0"
short_description: Install and configure Windows DFS
description:
	- Install FS-DFS-Namespace, FS-DFS-Replication and RSAT-DFS-Mgmt-Con windows features
	- Creates the root directory and root share directory for DFS
	- Configures the ACLs for the root directory and root share
	- Creates DFS root share
	- Configure the DFS namespace
	- Configure the DFS replication group
	- Configures the connection between the primary and non-primary DFS server
	- Defines the primary and non-primary DFS server

author:
- Pedro Aguiar (@phcaguiar)
options:
  dfs_primary_server_name:
    description:
      -  Hostname to primary DFS Server.
    required: yes
  dfs_nonprimary_server_name:
    description:
      - Hostname to nonprimary DFS Server.
    required: yes
  dfs_namespace_type:
    description:
      - DFS Namespace Type.
    required: yes
	choices: [ domainv1, domainv2, standalone ]
  dfs_share_name:
    description:
      - Root Share to DFS.
    required: yes
  dfs_root_path:
    description:
      - Root Path to DFS.
    required: yes
  dfs_replication_group_name:
    description:
      - Use this option to dfs replication group name. If no value is defined the value used will be the same as dfs_share_name.
  dfs_replicated_folder_name:
    description:
      - Use this option to dfs replicated folder name. If no value is defined the value used will be the same as dfs_share_name.
  enable_site_costing:
    description:
      - Boolean value. The default value is $false.
  enable_insite_referrals:
    description:
      - Boolean value. The default value is $false.
  enable_access_based_enumeration:
    description:
      - Boolean value. The default value is $false.
  enable_root_scalability:
    description:
      - Boolean value. The default value is $false.
  enable_target_failback:
    description:
      - Boolean value. The default value is $false.
'''

EXAMPLES = r'''
- name: Task to deploy DFS Standalone Namespace Type
  win_dfs:
    dfs_primary_server_name: mydfsserver01
    dfs_namespace_type: standalone
    dfs_share_name: Share
    dfs_root_path: C:\DFSRoot
    enable_site_costing: $true
- name: Task to deploy DFS DomainV2 Namespace Type
  win_dfs:
    dfs_primary_server_name: mydfsserver01
    dfs_nonprimary_server_name: mydfsserver02
    dfs_namespace_type: domainv2
    dfs_share_name: Share
    dfs_root_path: C:\DFSRoot
'''

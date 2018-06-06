#!powershell
# This file is part of Ansible

# Copyright (c) 2017 Ansible Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

#Requires -Module Ansible.ModuleUtils.Legacy
#Requires -Module Ansible.ModuleUtils.CommandUtil
#Requires -Module Ansible.ModuleUtils.FileUtil

$stopwatch = [system.diagnostics.stopwatch]::startNew()

$params = Parse-Args $args -supports_check_mode $false
$check_mode = Get-AnsibleParam -obj $params -name "_ansible_check_mode" -type "bool" -default $false

$dfs_primary_server_name = Get-AnsibleParam -obj $params "dfs_primary_server_name" -type "str"
$dfs_nonprimary_server_name = Get-AnsibleParam -obj $params "dfs_nonprimary_server_name" -type "str"
$dfs_namespace_type = Get-AnsibleParam -obj $params -name "dfs_namespace_type" -type "str" -validateset "standalone","domainv1","domainv2"
$dfs_share_name = Get-AnsibleParam -obj $params -name "dfs_share_name" -type "str"
$dfs_root_path = Get-AnsibleParam -obj $params -name "dfs_root_path" -type "path"
$dfs_replication_group_name = Get-AnsibleParam -obj $params -name "dfs_replication_group_name" -type "str" -default $dfs_share_name
$dfs_replicated_folder_name = Get-AnsibleParam -obj $params -name "dfs_replicated_folder_name" -type "str" -default $dfs_replication_group_name
$enable_site_costing = Get-AnsibleParam -obj $params -name "enable_site_costing" -type "bool" -default $false
$enable_insite_referrals = Get-AnsibleParam -obj $params -name "enable_insite_referrals" -type "bool" -default $false
$enable_access_based_enumeration = Get-AnsibleParam -obj $params -name "enable_access_based_enumeration" -type "bool" -default $false
$enable_root_scalability = Get-AnsibleParam -obj $params -name "enable_root_scalability" -type "bool" -default $false
$enable_target_failback = Get-AnsibleParam -obj $params -name "enable_target_failback" -type "bool" -default $false
$dfs_share_read_access = Get-AnsibleParam -obj $params -name "dfs_share_read_access" -type "str" -default ""
$dfs_share_full_access = Get-AnsibleParam -obj $params -name "dfs_share_full_access" -type "str" -default ""
$domain_name = (Get-WmiObject win32_computersystem).Domain
$primary_server_name = "\\"+$dfs_primary_server_name
$nonprimary_server_name = "\\"+$dfs_nonprimary_server_name
$dfsn_root_path_domain_type = "\\"+$domain_name+"\"+$dfs_share_name
$dfsn_root_primary_server_targetpath_domain_type = $primary_server_name+"."+$domain_name+"\"+$dfs_share_name
$dfsn_root_nonprimary_server_targetpath_domain_type = $nonprimary_server_name+"."+$domain_name+"\"+$dfs_share_name
$dfsn_root_primary_server_targetpath_standalone_type = $primary_server_name+"\"+$dfs_share_name

$result = @{
    changed = $false
}

### Instal DFS Function

Function InstallDFS {
        try {
                if ($dfs_namespace_type -eq $null) {
                        Fail-Json $result "The Parameter dfs_namespace_type is mandatory."
                } else {
                        $feature_is_installed = Get-WindowsFeature -Name FS-DFS-Namespace, FS-DFS-Replication, RSAT-DFS-Mgmt-Con
                        if ($feature_is_installed.Installed -eq $true) {
                                $result.changed = $false
                        }
                        else {
                                Install-WindowsFeature FS-DFS-Namespace, FS-DFS-Replication, RSAT-DFS-Mgmt-Con
                                $result.changed = $true
                        }
                }
        } catch [Exception] {
        Fail-Json $result "Some function error occurred on Function InstallDFS."
    }
}

### Function to create DFS Root Path

Function DFSPath {
        try {
                if ($dfs_root_path -eq $null) {
                        Fail-Json $result "The Parameter dfs_root_path is mandatory."
                }
                else {
                        $file_exists = Test-Path $dfs_root_path
                        if ($file_exists -eq $true) {
                        }
                        else {
                                New-Item "$dfs_root_path\$dfs_share_name" –type directory
                                $result.changed = $true
                        }
                }
        } catch [Exception] {
        Fail-Json $result "Some function error occurred on Function DFSPath."
    }
}

### Function to Set Default ACL on DFS Root Path

Function SetACLDFSRootPath {
        try {
                if ($dfs_root_path -eq $null) {
                    Fail-Json $result "The Parameter dfs_root_path is mandatory."
                }
                else {
			icacls "$dfs_root_path" /inheritance:r
			icacls "$dfs_root_path" /grant '"Creator Owner":(OI)(CI)(IO)M'
			icacls "$dfs_root_path" /grant '"Administrators":(OI)(CI)F'
			icacls "$dfs_root_path" /grant '"System":(OI)(CI)F'
                }
        } catch [Exception] {
        Fail-Json $result "Some function error occurred on Function SetACLDFSRootPath."
    }
}

### Function to Set Default ACL on DFS Root Share

Function SetACLDFSRootShare {
        try {
                if ($dfs_root_path -eq $null) {
                    Fail-Json $result "The Parameter dfs_root_path is mandatory."
                }
                else {
			icacls "$dfs_root_path\$dfs_share_name" /inheritance:r
			icacls "$dfs_root_path\$dfs_share_name" /grant '"Creator Owner":(OI)(CI)(IO)M'
			icacls "$dfs_root_path\$dfs_share_name" /grant '"Everyone":(OI)(CI)R'
			icacls "$dfs_root_path\$dfs_share_name" /grant '"Administrators":(OI)(CI)F'
			icacls "$dfs_root_path\$dfs_share_name" /grant '"System":(OI)(CI)F'
                }
        } catch [Exception] {
        Fail-Json $result "Some function error occurred on Function SetACLDFSRootShare."
    }
}

### Function to create DFS Root Share

Function DFSShare {
        try {
                if (!$dfs_share_name) {
                        Fail-Json $result "The Parameter dfs_share_name is mandatory."
                }
                else {
                    New-SMBShare –Name "$dfs_share_name" –Path "$dfs_root_path\$dfs_share_name" -FullAccess "Everyone"
                    $result.changed = $true
                }
        } catch [Exception] {
        Fail-Json $result "Some function error occurred on Function DFSShare."
    }
}

##DFS Config Functions

Function DfsnRoot {
        try {
                if (!$dfs_namespace_type) {
                        Fail-Json $result "The Parameter dfs_namespace_type is mandatory."
                }
                else {
                        if ($dfs_namespace_type -eq "domainv1" -or "domainv2") {
                                New-DfsnRoot -Path $dfsn_root_path_domain_type -TargetPath $dfsn_root_primary_server_targetpath_domain_type -Type $dfs_namespace_type -EnableSiteCosting $enable_site_costing -EnableInsiteReferrals $enable_insite_referrals -EnableAccessBasedEnumeration $enable_access_based_enumeration -EnableRootScalability $enable_root_scalability -EnableTargetFailback $enable_target_failback
                        }
                        elseif ($dfs_namespace_type -eq "standalone") {
                                New-DfsnRoot -TargetPath $dfsn_root_primary_server_targetpath_standalone_type -Type $dfs_namespace_type
                        }
                }
        } catch [Exception] {
        Fail-Json $result "Some function error occurred on Function DfsnRoot."
    }
}

Function DfsnRootTarget {
        try {
                if (!$dfs_namespace_type) {
                        Fail-Json $result "The Parameter dfs_namespace_type is mandatory."
                }
                else {
                        New-DfsnRootTarget -TargetPath "$dfsn_root_nonprimary_server_targetpath_domain_type" -Path "$dfsn_root_path_domain_type"
                }
        } catch [Exception] {
        Fail-Json $result "Some function error occurred on Function DfsnRootTarget."
    }
}

Function DfsReplicationGroup {
        try {
                if (!$dfs_share_name) {
                        Fail-Json $result "The Parameter dfs_share_name is mandatory."
                }
                else {
                New-DfsReplicationGroup -GroupName $dfs_replication_group_name | New-DfsReplicatedFolder -FolderName $dfs_replicated_folder_name | Add-DfsrMember -ComputerName "$dfs_primary_server_name.$domain_name" | Add-DfsrMember -ComputerName "$dfs_nonprimary_server_name.$domain_name"
                }
        } catch [Exception] {
        Fail-Json $result "Some function error occurred on Function DfsReplicationGroup."
    }
}

Function DfsrMembership {
        try {
                if (!$dfs_share_name) {
                        Fail-Json $result "The Parameter dfs_share_name is mandatory."
                }
                else {
                Set-DfsrMembership -GroupName $dfs_replication_group_name -FolderName $dfs_replicated_folder_name -ContentPath "$dfs_root_path\$dfs_share_name" -ComputerName "$dfs_primary_server_name.$domain_name","$dfs_nonprimary_server_name.$domain_name" $true -Force
                }
        } catch [Exception] {
        Fail-Json $result "Some function error occurred on Function DfsrMembership."
    }
}

Function DfsrConnection {
        try {
                if (!$dfs_share_name) {
                        Fail-Json $result "The Parameter dfs_share_name is mandatory."
                }
                else {
                Add-DfsrConnection -GroupName $dfs_share_name -SourceComputerName "$dfs_primary_server_name.$domain_name" -DestinationComputerName "$dfs_nonprimary_server_name.$domain_name"
                }
        } catch [Exception] {
        Fail-Json $result "Some function error occurred on Function DfsrConnection."
    }
}

Function DfsrSetPrimaryMembership {
        try {
                if (!$dfs_root_path) {
                        Fail-Json $result "The Parameter dfs_root_path is mandatory."
                }
                else {
                Set-DfsrMembership -GroupName $dfs_share_name -FolderName $dfs_replicated_folder_name -ContentPath $dfs_root_path\$dfs_share_name -ComputerName "$dfs_primary_server_name.$domain_name" -PrimaryMember $true -Force
                }
        } catch [Exception] {
        Fail-Json $result "Some function error occurred on Function DfsrSetPrimaryMembership."
    }
}

## Run Functions

InstallDFS
DFSPath
DFSShare
SetACLDFSRootPath
SetACLDFSRootShare
DfsnRoot
DfsnRootTarget
DfsReplicationGroup
DfsrMembership
DfsrConnection
DfsrSetPrimaryMembership

Exit-Json $result

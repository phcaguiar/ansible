param (
    [Parameter(Mandatory=$true)]$domain,
    [Parameter(Mandatory=$true)]$username,
    [Parameter(Mandatory=$true)]$password
)

$ErrorActionPreference = 'Stop'

$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

try {
    Remove-Computer -UnjoinDomaincredential $credential -WorkgroupName "WORKGROUP" -Verbose -Force -PassThru -Restart -ErrorAction Stop 
}
catch [InvalidOperationException] {
    Write-Output $_.Exception.Message

    if ($_.Exception.Message -like '*is not in a domain*') {
        exit 1
    } else {
        exit 2
    }
}
catch {
    throw $_
    exit 3
}
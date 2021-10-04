<#
# CITRA IT - EXCELÊNCIA EM TI
# SCRIPT PARA LOCALIZAR SERVIÇOS SENDO EXECUTADOS COM CONTAS NÃO PADRÃO
# AUTOR: luciano@citrait.com.br
# DATA: 01/10/2021
# Homologado para executar no Windows 7 ou Server 2008R2+
# EXAMPLO DE USO: Powershell -ExecutionPolicy ByPass -File C:\scripts\PS_List_Services_Custom_Accounts
#>


#
# Adding graphical libraries
#
Add-Type -AssemblyName System.Windows.Forms


#
# Creating the main form
#
$form = new-object system.windows.forms.form
$form.AutoSize = $true
$form.width = 400
$form.Text = "List Services running with Custom Accounts (Not Builtin)"


#
# Creating the gridview to list services
#
$grid = new-object system.windows.forms.datagridview
$grid.AutoSize = $true
$grid.ReadOnly = $true
$grid.Dock = [System.Windows.Forms.DockStyle]::Fill
$grid.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::AllCells


#
# Populating table Headers
#
$tabledata = new-object system.data.datatable
$tabledata.Columns.Add("Name") | out-null
$tabledata.Columns.Add("State") | out-null
$tabledata.Columns.Add("Account") | out-null
$tabledata.Columns.Add("StartMode") | out-null



#
# Listing Services on Local Computer
#
$startname_blacklist = @('localSystem','NT AUTHORITY\LocalService','NT AUTHORITY\NetworkService')
$services = Get-WMIObject Win32_Service | `
	Where-Object { $_.StartName -notin $startname_blacklist  }


#
# Checking if any service is not running with builtin account
#
If($services.count -eq 0)
{
	[System.Windows.Forms.MessageBox]::Show("ALL services running only with builtin accounts !")
	exit
}
$services | 
	ForEach-Object { $tabledata.Rows.Add([object] @($_.DisplayName, $_.State, $_.StartName, $_.StartMode))  | out-null}


#
# Showing the main Form
#
$grid.datasource = $tabledata
$form.Controls.Add($grid)
$form.showdialog()


	

Param(
	[Parameter(Mandatory=$true)]
	[string]$user,
	[Parameter(Mandatory=$true)]
	[string]$password
)

$req = Invoke-WebRequest "http://www.programmez.com/user/"

$formId=$req.forms["user-login"].Fields["form_build_id"]
$operation=$req.forms["user-login"].Fields["edit-submit"]

$postParams = @{"name"=$user;"pass"=$password;"form_id"="user_login";"form_build_id"=$formId;"op"=$operation}

$req = Invoke-WebRequest "http://www.programmez.com/user/" -Method POST -Body $postParams
$req = Invoke-WebRequest "http://www.programmez.com/user/36971/archives/"
$archives = $req.Links | Where-Object {$_.innerText -like "*.pdf"}

$archiveNames = New-Object System.Collections.ArrayList
foreach($item in $archives.innerText) {
	$item = "mag_pdf_" + $item
	[void] $archiveNames.Add($item)
}

#$archiveNames
$downloaded = Get-ChildItem -Path "S:\Etudes\Commun_Etudes\Livres\Programmez" -File | Where-Object -Filter {$PSItem.Name -like "mag_*.pdf"}

foreach ($item in $archiveNames){
	if ( $downloaded -notcontains $item ) {
		$item
	}
}
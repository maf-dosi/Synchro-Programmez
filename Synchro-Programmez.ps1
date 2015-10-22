Param(
	[Parameter(Mandatory=$true)]
	[string]$user,
	[Parameter(Mandatory=$true)]
	[string]$password
)
$filepath = "S:\Etudes\Commun_Etudes\Livres\Programmez\"
$baseurl = "http://www.programmez.com"

$req = Invoke-WebRequest "http://www.programmez.com/user/"
$formId=$req.forms["user-login"].Fields["form_build_id"]
$operation=$req.forms["user-login"].Fields["edit-submit"]

$postParams = @{"name"=$user;"pass"=$password;"form_id"="user_login";"form_build_id"=$formId;"op"=$operation}

$req = Invoke-WebRequest "$baseurl/user/" -Method POST -Body $postParams -SessionVariable myWebSession
$req = Invoke-WebRequest "$baseurl/user/36971/archives/" -WebSession $myWebSession
$archives = $req.Links | Where-Object {$_.innerText -like "*.pdf"}

$archiveNames = New-Object System.Collections.ArrayList
$paths = @{}
foreach($item in $archives) {
	$name = "mag_pdf_" + $item.innerText
	[void] $archiveNames.Add($name)
	$paths.Add($name,$item.href)
}

$downloaded = Get-ChildItem -Path $filepath -File | Where-Object -Filter {$PSItem.Name -like "mag_*.pdf"}
$downloaded = $downloaded.Name

foreach ($item in $archiveNames){
	if ( $downloaded -notcontains $item ) {
		$url = $baseurl + $paths["$item"]
		Invoke-WebRequest $url -OutFile "$filepath$item" -WebSession $myWebSession
	}
}




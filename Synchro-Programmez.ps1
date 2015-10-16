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
#$req
#/user/36971/archives
#$req.rawcontent
$req = Invoke-WebRequest "http://www.programmez.com/user/36971/archives/"
$req.Links | Where-Object {$_.innerText -like "*.pdf"}
$SQLServer = "localhost"
$db = "master"

$Username = "leansql"
$Password = "Edenred2021!"

invoke-sqlcmd -inputfile "Tenant\CreateDatabases.sql" -serverinstance $SQLServer -database $db 

Write-Host "Finished Create DBs"
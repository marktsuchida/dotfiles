Set-PSReadLineOption -EditMode Emacs

if (-not ($Env:Path.Split(';') -contains "$Env:USERPROFILE\bin")) {
	$Env:Path = "$Env:USERPROFILE\bin;$Env:Path"
}

$Env:PIP_REQUIRE_VIRTUALENV = "true"

function .. { Set-Location '..' }
function ... { Set-Location '..\..' }
function .... { Set-Location '..\..\..' }
function ..... { Set-Location '..\..\..\..' }
function ...... { Set-Location '..\..\..\..\..' }
function ....... { Set-Location '..\..\..\..\..\..' }
function ........ { Set-Location '..\..\..\..\..\..\..' }
function ......... { Set-Location '..\..\..\..\..\..\..\..' }
function .......... { Set-Location '..\..\..\..\..\..\..\..\..' }

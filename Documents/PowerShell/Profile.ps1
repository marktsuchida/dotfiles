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

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "$HOME\miniforge3\Scripts\conda.exe") {
    (& "$HOME\miniforge3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion

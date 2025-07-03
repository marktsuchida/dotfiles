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

function code. { & code . }

if ($Env:GIT_INSTALL_ROOT) {
    Set-Alias -Name "less" -Value "$Env:GIT_INSTALL_ROOT\usr\bin\less.exe"
}

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "$HOME\miniforge3\Scripts\conda.exe") {
    (& "$HOME\miniforge3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion

#region mamba initialize
# !! Contents within this block are managed by 'mamba shell init' !!
$Env:MAMBA_ROOT_PREFIX = "$HOME\AppData\Roaming\mamba"
$Env:MAMBA_EXE = "$HOME\AppData\Local\micromamba\micromamba.exe"
(& $Env:MAMBA_EXE 'shell' 'hook' -s 'powershell' -r $Env:MAMBA_ROOT_PREFIX) | Out-String | Invoke-Expression
#endregion

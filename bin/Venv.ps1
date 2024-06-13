if (-Not (Test-Path -Path 'venv' -PathType Container)) {
	Write-Output 'Creating venv...'
	python -m venv venv
	"*" | Out-File -FilePath 'venv\.gitignore'
	.\venv\Scripts\Activate.ps1
	python -m pip install --upgrade pip setuptools
} else {
	.\venv\Scripts\Activate.ps1
}

Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-Alias lg lazygit

function y
{
	$tmp = (New-TemporaryFile).FullName
	yazi.exe $args --cwd-file="$tmp"
	$cwd = Get-Content -Path $tmp -Encoding UTF8
	if ($cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container))
	{
		Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
	}
	Remove-Item -Path $tmp
}

function l
{ eza --icons --group-directories-first -F $args
}
function ll
{ eza --icons --group-directories-first --git -lhF $args
}
function la
{ eza --icons --group-directories-first --git -lahF $args
}
function lt
{ eza --icons -F --tree --level=2 $args
}

# uv and uvx completions
$uvCompPath = "$env:LOCALAPPDATA\uv\uv-completions.ps1"
$uvxCompPath = "$env:LOCALAPPDATA\uv\uvx-completions.ps1"
if (-not (Test-Path $uvCompPath))
{
	(& uv generate-shell-completion powershell) | Out-File -Encoding UTF8 $uvCompPath
}
if (-not (Test-Path $uvxCompPath))
{
	(& uvx generate-shell-completion powershell) | Out-File -Encoding UTF8 $uvxCompPath
}

. $uvCompPath
. $uvxCompPath


# Lazy-load conda on first use
function Initialize-Conda
{
	$condaExe = "C:\Users\Ian\miniforge3\Scripts\conda.exe"
	if (Test-Path $condaExe)
	{
		(& $condaExe "shell.powershell" "hook") | Out-String | Where-Object { $_ } | Invoke-Expression
	}
	Remove-Item Function:\__Initialize-Conda -ErrorAction SilentlyContinue
}

function conda
{
	Initialize-Conda
	conda @args
}

function updateapp {
	npm update -g
	scoop update *
}

function cleancache {
	npm cache clean --force
	pnpm store prune
	uv cache clean
	pip cache purge
	scoop cleanup -k *
}
# Invoke-Expression (&starship init powershell)

param(
    [string]$ManifestPath = "$(Split-Path -Parent $PSScriptRoot)/games/games.manifest.json"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git is required"
}

if (-not (Get-Command ConvertFrom-Json -ErrorAction SilentlyContinue)) {
    throw "PowerShell JSON support is required"
}

$root = (Resolve-Path "$(Split-Path -Parent $PSScriptRoot)").Path
$external = Join-Path $root "external"
$gamesDir = Join-Path $external "games"
$sdkDir = Join-Path $external "source-sdk-2013"

New-Item -ItemType Directory -Force -Path $gamesDir | Out-Null

$manifest = Get-Content -Raw $ManifestPath | ConvertFrom-Json

if (-not (Test-Path (Join-Path $sdkDir ".git"))) {
    git clone --branch $manifest.sdk.branch $manifest.sdk.repo $sdkDir
}
else {
    git -C $sdkDir fetch origin
    git -C $sdkDir checkout $manifest.sdk.branch
    git -C $sdkDir pull --ff-only
}

foreach ($game in $manifest.games) {
    $target = Join-Path $gamesDir $game.id

    if (-not (Test-Path (Join-Path $target ".git"))) {
        git clone --branch $game.branch $game.repo $target
    }
    else {
        git -C $target fetch origin
        git -C $target checkout $game.branch
        git -C $target pull --ff-only
    }
}

Write-Host "Bootstrap complete. Repositories are available in: $external"

# Installation de la GMAO sur le PC (à relancer après chaque mise à jour importante).
# Utilisation : powershell -ExecutionPolicy Bypass -File .\setup.ps1
$ErrorActionPreference = 'Stop'
$env:PYTHONUTF8 = '1'
$racine = $PSScriptRoot
$backend = Join-Path $racine 'backend'
$frontend = Join-Path $racine 'frontend'

function Etape($texte) { Write-Host ''; Write-Host "==> $texte" -ForegroundColor Cyan }
function Echec($texte) { Write-Host ''; Write-Host "ERREUR : $texte" -ForegroundColor Red; Write-Host 'Copiez ce message et donnez-le à Claude.' -ForegroundColor Red; exit 1 }
function Verifier($texte) { if ($LASTEXITCODE -ne 0) { Echec $texte } }

try {
    Etape 'Vérification des outils'
    if (Get-Command py -ErrorAction SilentlyContinue) { $python = 'py'; $pythonArgs = @('-3') }
    elseif (Get-Command python -ErrorAction SilentlyContinue) { $python = 'python'; $pythonArgs = @() }
    else { Echec 'Python est introuvable. Voir 00-COMMENCER-ICI.md, étape 3.' }
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { Echec 'Node.js (npm) est introuvable. Voir 00-COMMENCER-ICI.md, étape 4.' }

    Set-Location $backend
    $venvPython = Join-Path $backend '.venv\Scripts\python.exe'
    if (-not (Test-Path $venvPython)) {
        Etape 'Création de l''environnement Python du projet'
        & $python @pythonArgs -m venv .venv
        Verifier 'impossible de créer l''environnement Python (.venv).'
    }

    Etape 'Installation des outils Python'
    & $venvPython -m pip install --disable-pip-version-check -q -r requirements.txt
    Verifier 'installation des outils Python impossible.'

    if (-not (Test-Path (Join-Path $backend '.env'))) {
        Etape 'Création du fichier de configuration .env'
        Copy-Item (Join-Path $backend '.env.example') (Join-Path $backend '.env')
    }

    Etape 'Création / mise à jour de la base de données'
    & $venvPython -m flask --app app db upgrade
    Verifier 'mise à jour de la base de données impossible.'

    Etape 'Données de départ (ateliers, comptes de démo...)'
    & $venvPython -m flask --app app seed
    Verifier 'remplissage de la base impossible.'

    Etape 'Installation des outils de l''affichage (2 à 3 minutes la première fois)'
    Set-Location $frontend
    npm install --no-fund --no-audit
    Verifier 'installation des outils de l''affichage (npm install) impossible.'
}
catch {
    Echec $_.Exception.Message
}
finally {
    Set-Location $racine
}

Write-Host ''
Write-Host 'Installation terminée. Lancer : .\dev.ps1' -ForegroundColor Green

# Glotto-assistenten - installation for en ny anvandare.
#
# Kor i PowerShell:
#   irm https://raw.githubusercontent.com/glottomania/glotto-assistent/main/installation/installera.ps1 | iex
#
# Skriptet kan koras om hur manga ganger som helst. Det skriver aldrig over en
# befintlig konfiguration och raderar ingenting.

& {
$Repo = 'https://raw.githubusercontent.com/glottomania/glotto-assistent/main'
$Sep = [IO.Path]::DirectorySeparatorChar
$script:Resultat = New-Object System.Collections.ArrayList

function Rad([string]$Status, [string]$Vad, [string]$Text) {
    [void]$script:Resultat.Add([pscustomobject]@{ Status = $Status; Vad = $Vad; Text = $Text })
}

function Skriv-Utf8([string]$Sokvag, [string]$Text) {
    # UTF-8 utan BOM - Claude laser filerna med Python.
    [IO.File]::WriteAllText($Sokvag, $Text, (New-Object Text.UTF8Encoding $false))
}

function Las-Json([string]$Sokvag) {
    $text = [IO.File]::ReadAllText($Sokvag, [Text.Encoding]::UTF8)
    return $text | ConvertFrom-Json
}

function Har-App([string]$Namn) {
    try {
        return [bool](Get-StartApps -ErrorAction Stop | Where-Object { $_.Name -like "$Namn*" })
    } catch {
        return $null   # okant - Get-StartApps saknas
    }
}

function Visa-Resultat {
    Write-Host ''
    Write-Host '==================== Resultat ====================' -ForegroundColor Cyan
    foreach ($r in $script:Resultat) {
        $farg = switch ($r.Status) { 'OK' { 'Green' } 'Fel' { 'Red' } default { 'Yellow' } }
        Write-Host ('{0,-7}' -f $r.Status) -ForegroundColor $farg -NoNewline
        Write-Host ('{0,-17}' -f $r.Vad) -NoNewline
        Write-Host $r.Text
    }
    Write-Host '==================================================' -ForegroundColor Cyan
}

Write-Host ''
Write-Host 'Glotto-assistenten - installation' -ForegroundColor Cyan
Write-Host ''

# --- 1. Virtualisering --------------------------------------------------------
# Claude arbetar i dina mappar via en liten virtuell dator. Utan virtualisering
# saknas den helt, och det marks forst langt senare.
$virtOk = $false
try {
    $virtOk = [bool](Get-CimInstance Win32_ComputerSystem -ErrorAction Stop).HypervisorPresent
} catch { }
if ($virtOk) {
    Rad 'OK' 'Virtualisering' 'påslagen'
} else {
    Write-Host 'Virtualisering är avstängd. Den behövs för att Claude ska kunna arbeta i dina mappar.' -ForegroundColor Yellow
    $svar = Read-Host 'Slå på den nu? Windows frågar om lov, och datorn behöver startas om efteråt (j/n)'
    if ($svar -match '^[jJyY]') {
        try {
            Start-Process powershell -Verb RunAs -Wait -ArgumentList @(
                '-NoProfile', '-Command',
                'Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart | Out-Null')
            Rad 'Fel' 'Virtualisering' 'påslagen nu - starta om datorn och kör skriptet igen. Är den fortfarande avstängd efter omstart kan den vara avslagen i datorns BIOS.'
        } catch {
            Rad 'Fel' 'Virtualisering' 'kunde inte slås på (godkände du frågan?). Kör skriptet igen.'
        }
    } else {
        Rad 'Fel' 'Virtualisering' 'avstängd - kör skriptet igen när du vill slå på den'
    }
}

# --- 2. Program ----------------------------------------------------------------
switch (Har-App 'Claude') {
    $true  { Rad 'OK' 'Claude-appen' 'installerad' }
    $false { Rad 'Fel' 'Claude-appen' 'hittas inte - installera från claude.ai/download' }
    default { Rad 'Okänt' 'Claude-appen' 'kunde inte kontrolleras' }
}
switch (Har-App 'Obsidian') {
    $true  { Rad 'OK' 'Obsidian' 'installerad' }
    $false { Rad 'Fel' 'Obsidian' 'hittas inte - installera från obsidian.md (gratis)' }
    default { Rad 'Okänt' 'Obsidian' 'kunde inte kontrolleras' }
}

# --- 3. Teammappen -------------------------------------------------------------
# Teamfilen .glotto\team.json ligger i teammappen, som administratören delat med
# dig. Leta i de synkade mapparna i hemkatalogen.
Write-Host 'Letar efter teammappen ...'
$rotter = @(Get-ChildItem -Path $HOME -Directory -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match 'Dropbox|OneDrive|Google Drive|Box' })
$hittade = @()
foreach ($rot in $rotter) {
    $hittade += @(Get-ChildItem -Path $rot.FullName -Filter 'team.json' -Recurse -Depth 3 -Force -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Directory.Name -eq '.glotto' })
}
$hittade = @($hittade | Sort-Object FullName -Unique)

$teamfil = $null
if ($hittade.Count -eq 1) {
    $teamfil = $hittade[0]
} elseif ($hittade.Count -gt 1) {
    Write-Host 'Du är med i flera team:'
    for ($i = 0; $i -lt $hittade.Count; $i++) {
        $n = (Las-Json $hittade[$i].FullName).namn
        Write-Host ('  {0}. {1}  ({2})' -f ($i + 1), $n, $hittade[$i].Directory.Parent.FullName)
    }
    $val = Read-Host 'Vilket team installerar du nu? Skriv numret'
    if ($val -match '^\d+$' -and [int]$val -ge 1 -and [int]$val -le $hittade.Count) {
        $teamfil = $hittade[[int]$val - 1]
    }
} else {
    Write-Host 'Hittade ingen teammapp automatiskt.' -ForegroundColor Yellow
    $sokvag = Read-Host 'Klistra in sökvägen till teammappen, eller tryck Enter för att avbryta'
    if ($sokvag) {
        $kandidat = Join-Path (Join-Path $sokvag.Trim('"') '.glotto') 'team.json'
        if (Test-Path $kandidat) { $teamfil = Get-Item $kandidat }
    }
}

if (-not $teamfil) {
    Rad 'Fel' 'Teammapp' 'hittas inte. Be administratören dela teammappen med dig, vänta tills den synkat klart och kör skriptet igen.'
    Visa-Resultat
    Read-Host 'Läs listan ovan. Tryck Enter för att stänga när du är klar'
    return
}

$team = Las-Json $teamfil.FullName
$teammapp = $teamfil.Directory.Parent.FullName
Rad 'OK' 'Teammapp' ('{0}  (team {1})' -f $teammapp, $team.namn)

$hem = (Resolve-Path $HOME).Path.TrimEnd($Sep)
if (-not $teammapp.StartsWith($hem + $Sep, [StringComparison]::OrdinalIgnoreCase)) {
    Rad 'Fel' 'Teammapp' 'ligger utanför din hemkatalog - flytta den dit (till exempel via Dropbox inställningar) och kör skriptet igen'
    Visa-Resultat
    Read-Host 'Läs listan ovan. Tryck Enter för att stänga när du är klar'
    return
}
$deladMapp = $teammapp.Substring($hem.Length + 1).Replace([string]$Sep, '/')

# --- 4. Vem är du --------------------------------------------------------------
$aktiva = @($team.medlemmar | Where-Object { $_.aktiv -ne $false })
$projektmapp = Join-Path $HOME ('{0} Assistant' -f $team.namn)
$config = Join-Path (Join-Path $projektmapp '.glotto') 'config.json'

$anvandare = $null
if (Test-Path $config) {
    $befintlig = Las-Json $config
    $anvandare = $befintlig.anvandare
    Write-Host ('Du är redan uppsatt som {0}.' -f $anvandare)
} else {
    Write-Host ''
    Write-Host ('Medlemmar i {0}:' -f $team.namn)
    for ($i = 0; $i -lt $aktiva.Count; $i++) {
        Write-Host ('  {0}. {1}' -f ($i + 1), $aktiva[$i].namn)
    }
    $val = Read-Host 'Vem är du? Skriv numret'
    if ($val -match '^\d+$' -and [int]$val -ge 1 -and [int]$val -le $aktiva.Count) {
        $anvandare = $aktiva[[int]$val - 1].anvandare
    }
}
if (-not $anvandare -or -not ($aktiva | Where-Object { $_.anvandare -eq $anvandare })) {
    Rad 'Fel' 'Medlem' 'du står inte bland teamets medlemmar. Be administratören lägga till dig och kör skriptet igen.'
    Visa-Resultat
    Read-Host 'Läs listan ovan. Tryck Enter för att stänga när du är klar'
    return
}
Rad 'OK' 'Medlem' $anvandare

# --- 5. Projektmappen och konfigurationen ---------------------------------------
foreach ($u in @('', 'verkstad', 'utdata', '.glotto')) {
    $m = Join-Path $projektmapp $u
    if (-not (Test-Path $m)) { New-Item -ItemType Directory -Path $m | Out-Null }
}
Rad 'OK' 'Projektmapp' $projektmapp

if (Test-Path $config) {
    $befintlig = Las-Json $config
    if ($befintlig.anvandare -eq $anvandare -and $befintlig.delad_mapp -eq $deladMapp) {
        Rad 'OK' 'Konfiguration' 'finns redan och stämmer'
    } else {
        Rad 'Fel' 'Konfiguration' ('finns redan med andra värden ({0}, {1}) - ändras inte. Stämmer den inte, fråga administratören.' -f $befintlig.anvandare, $befintlig.delad_mapp)
    }
} else {
    $json = "{`n  `"anvandare`": `"$anvandare`",`n  `"delad_mapp`": `"$deladMapp`"`n}`n"
    Skriv-Utf8 $config $json
    Rad 'OK' 'Konfiguration' 'skapad'
}

# --- 6. Handboken --------------------------------------------------------------
try {
    $handbok = Invoke-RestMethod -Uri "$Repo/HANDBOK.md" -UseBasicParsing
    $mal = Join-Path $projektmapp 'Handbok.md'
    if ((Test-Path $mal) -and ([IO.File]::ReadAllText($mal, [Text.Encoding]::UTF8) -ne $handbok)) {
        $korg = Join-Path $projektmapp '.papperskorg'
        if (-not (Test-Path $korg)) { New-Item -ItemType Directory -Path $korg | Out-Null }
        Move-Item $mal (Join-Path $korg ('{0} Handbok.md' -f (Get-Date -Format 'yyyy-MM-ddTHHmm')))
    }
    Skriv-Utf8 $mal $handbok
    Rad 'OK' 'Handbok' 'senaste versionen ligger i projektmappen'
} catch {
    Rad 'Senare' 'Handbok' 'kunde inte hämtas - kör skriptet igen senare'
}

# --- 7. Dropbox ska inte synka Obsidians fönsterläge ------------------------------
if ($team.lagring -eq 'dropbox') {
    $ws = Join-Path (Join-Path $teammapp '.obsidian') 'workspace.json'
    if (Test-Path $ws) {
        try {
            Set-Content -Path $ws -Stream com.dropbox.ignored -Value 1 -ErrorAction Stop
            Rad 'OK' 'Dropbox' 'synkar inte Obsidians fönsterläge'
        } catch {
            Rad 'Fel' 'Dropbox' 'kunde inte ställas in - kör skriptet igen'
        }
    } else {
        Rad 'Senare' 'Dropbox' 'öppna teammappen i Obsidian en gång och kör sedan skriptet igen'
    }
}

# --- Klart ---------------------------------------------------------------------
Visa-Resultat
Write-Host ''
Write-Host 'Sedan, i Claude-appen:' -ForegroundColor Cyan
Write-Host '  1. Customize > Plugins > + Add > "Add from a repository" > glottomania/glotto-assistent > Install'
Write-Host ('  2. Starta en ny uppgift och anslut mappen {0}' -f $projektmapp)
Write-Host '  3a. Använder teamet Google: koppla Google Drive under Connectors, med ditt jobbkonto'
Write-Host '  3b. Använder teamet Microsoft: koppla Microsoft 365 under Connectors, med ditt jobbkonto'
Write-Host '  4. Säg "visa status" - Claude kontrollerar resten och säger till om något saknas'
Write-Host ''
Write-Host ('I Obsidian: öppna teammappen och {0} som två separata valv.' -f $projektmapp)
Write-Host ''
Write-Host 'Stäng inte fönstret än. Gör stegen ovan först - de står inte någon annanstans.' -ForegroundColor Yellow
Write-Host 'Du kan alltid se dem igen genom att köra skriptet en gång till.' -ForegroundColor Yellow
Write-Host ''
Read-Host 'Tryck Enter för att stänga när du är klar'
}

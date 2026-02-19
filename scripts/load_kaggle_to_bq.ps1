param(
    [string]$ProjectId = "ufc-odds-ml",
    [string]$Dataset = "ufc_raw",
    [string]$KaggleDataset = "neelagiriaditya/ufc-datasets-1994-2025",
    [string]$DataDir = (Join-Path $PSScriptRoot "..\\data\\raw"),
    [string]$Location = "EU",
    [switch]$SkipDownload,
    [switch]$Replace
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -Path $DataDir)) {
    New-Item -ItemType Directory -Force -Path $DataDir | Out-Null
}

if (-not $SkipDownload) {
    if (-not (Get-Command kaggle -ErrorAction SilentlyContinue)) {
        throw "Kaggle CLI not found. Install with 'pip install kaggle' and place kaggle.json in %USERPROFILE%\\.kaggle\\kaggle.json."
    }

    Write-Host "Downloading Kaggle dataset to $DataDir"
    kaggle datasets download -d $KaggleDataset -p $DataDir --unzip
}

if (-not (Get-Command bq -ErrorAction SilentlyContinue)) {
    throw "bq CLI not found. Install Google Cloud SDK and run 'gcloud auth login'."
}

$csvFiles = Get-ChildItem -Path $DataDir -Filter *.csv
if ($csvFiles.Count -eq 0) {
    throw "No CSV files found in $DataDir"
}

$schemaMap = @{
    "event_details" = "event_id:STRING,fight_id:STRING,date:STRING,location:STRING,winner:STRING,winner_id:STRING"
}

foreach ($file in $csvFiles) {
    $tableName = [IO.Path]::GetFileNameWithoutExtension($file.Name) -replace '[^A-Za-z0-9_]', '_'
    Write-Host "Loading $($file.Name) -> ${ProjectId}:${Dataset}.$tableName"

    $loadArgs = @()
    $loadArgs += "--location=$Location"
    $loadArgs += "load"
    if ($Replace) { $loadArgs += "--replace" }
    $loadArgs += "--source_format=CSV"
    $loadArgs += "--skip_leading_rows=1"

    if ($schemaMap.ContainsKey($tableName)) {
        $loadArgs += "$ProjectId`:$Dataset.$tableName"
        $loadArgs += $file.FullName
        $loadArgs += $schemaMap[$tableName]
    } else {
        $loadArgs += "--autodetect"
        $loadArgs += "$ProjectId`:$Dataset.$tableName"
        $loadArgs += $file.FullName
    }

    & bq @loadArgs
}

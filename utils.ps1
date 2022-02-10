Import-Module $PSScriptRoot\PSYaml-master\PSYaml

$global:confObject = $null

Function OutputFile
{
   Param ([String]$filename, [string]$content)
   Add-content -Encoding UTF8 $filename -value $content
}

Function Init {
    # 配置ファイルから読取
    Write-host "配置ファイルから読取開始"
    $confString = Get-Content $PSScriptRoot\conf.yml
    $content = ''
    foreach ($line in $confString) { $content = $content + "`n" + $line }
    $global:confObject = ConvertFrom-YAML $content
    Write-host "配置ファイルから読取終了"
}
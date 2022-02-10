<#
Gitコミット一覧ファイルからコミット一覧を読み込んで
指定されたGitから歴史コミット情報を取得しながらファイルの形に出力すること。
使用例：

.\getGitCommitInfo.ps1 logfilename
Or
.\getGitCommitInfo.ps1 

#>

param (
        [parameter(mandatory=$false)][string]$logFile
    )

$savedEncoding = [Console]::OutputEncoding
[Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8


. .\utils.ps1

# 初期化
Init

# 出力ファイル名を決める
if (-not ([string]::IsNullOrEmpty($logFile))) {
    $commitInfoFile = "$PSScriptRoot\output\$logFile"
    $filename = $logFile
} else {
    $commitInfoFile = "$PSScriptRoot\output\$($global:confObject.commit_info)"
    $filename = $global:confObject.commit_info
}


# Gitルートパスに切替
Write-host "Git更新開始"
$git_root_path = $global:confObject.git_root_path
cd $git_root_path
#git pull
Write-host "Git更新完了"

# あらかじめ出力内容をクリア（もし既に出力があった場合）
if (Test-Path -Path $commitInfoFile -PathType Leaf) {
    Clear-Content $commitInfoFile
} else {
    if (-not (Test-Path -Path "$PSScriptRoot\output")) {
        New-Item -Path "$PSScriptRoot\output" -ItemType Directory | Out-Null
    }
    New-Item -Path "$PSScriptRoot\output" -Name $filename -ItemType "file" -Value ""
}


$countOfCommits = 0
$countOfRows = 0
# Gitから情報を取得する
foreach($line in Get-Content "${PSScriptRoot}\$($global:confObject.commits)") {
    $countOfCommits++

    $time = (git show  -s --pretty="%ai" $line)
    $author = git show  -s --pretty="%cN" $line
    $subject = git show  -s --pretty="%s" $line
    
    $fileList = git show --pretty="" --name-only $line
    
    $chunksFileList = $fileList -split "(\r*\n){2,}"
    Foreach ($file in $chunksFileList) {
        $countOfRows++
        OutputFile -content ("{0}`t{1}`t{2}`t{3}`t{4}" -f ${time}, ${author}, ${subject}, ${line}, ${file}) -filename $commitInfoFile
    }
}

# 完了情報お知らせ
write-host ("{0} commits, and totally {1} rows of contents are outputed!" -f $countOfCommits, $countOfRows)
write-host ("Output file name is {0}" -f $commitInfoFile)

cd $PSScriptRoot

[Console]::OutputEncoding = $savedEncoding
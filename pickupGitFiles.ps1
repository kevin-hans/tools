<#
指定されたGitコミット時点のファイルをフォルダー階層を保持しながら拾う。
使用例：

.\pickupGitFiles.ps1 2a762debfd3

#>

param (
        [parameter(mandatory=$true)][string]$commitId
    )

. .\utils.ps1

# 初期化
Init


$script_name = $MyInvocation.MyCommand.Name

$Logfile = "$PSScriptRoot\log\${script_name}.log"

# Gitルートパスに切替
Write-host "Git更新開始"
$git_root_path = $global:confObject.git_root_path
cd $git_root_path
git pull | Out-Null
git reset --hard $commitId | Out-Null
Write-host "Git更新完了"


# ログファイルを作成
if (Test-Path -Path $Logfile -PathType Leaf) {
    Clear-Content $Logfile
} else {
    if (-not (Test-Path -Path "$PSScriptRoot\log")) {
        New-Item -Path "$PSScriptRoot\log" -ItemType Directory | Out-Null
    }
    New-Item -Path "$PSScriptRoot\log" -Name ${script_name}.log -ItemType "file" -Value "" | Out-Null
}

$dest_dir = "$PSScriptRoot\$($global:confObject.output_folder)$commitId"
If(!(test-path $dest_dir)) {
    New-Item -ItemType Directory -Force -Path $dest_dir | Out-Null
} else {
    Remove-Item "${dest_dir}\*" -Recurse -Force | Out-Null
}


OutputFile -content "例示：○：ファイル存在／×:ファイル存在しない" -filename $Logfile
$successCount = 0
$errorCount = 0
$totalCount = 0

Write-host "Gitからファイルを拾う開始"
foreach($line in Get-Content "${PSScriptRoot}\$($global:confObject.files)") {

    $totalCount++

    if (-not(Test-Path -Path "${git_root_path}\${line}" -PathType Leaf)) {
        Write-host "× `t ${git_root_path}\${line}"
        OutputFile -content "× `t ${git_root_path}\${line}" -filename $Logfile
        $errorCount++
    } else {
        Write-host "○ `t ${git_root_path}\${line}"
        OutputFile -content "○ `t ${git_root_path}\${line}" -filename $Logfile
        
        
        $fileobj = Get-Item "${git_root_path}\${line}"
        
        $dest = $fileobj.DirectoryName.Replace($git_root_path, $dest_dir)
        $filename = $fileobj.Name

        If (!($dest.Contains('.')) -and !(Test-Path $dest))
        {
            mkdir $dest | Out-Null
        }
        
        # Copy-Item -Path "${git_root_path}\${line}" $dest_dir
        Copy-Item -Path "${git_root_path}\${line}" "${dest}\$filename"
        $successCount++
    }
}

cd $PSScriptRoot
Write-host "Gitからファイルを拾う終了"
write-host ("In totally {0} files, {1} files are picked up, {2} errors happened" -f $totalCount, $successCount, $errorCount)
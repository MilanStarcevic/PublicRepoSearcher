param (
    [string[]]$keywordsToSearchFor = "PublicRepoSearch",
    [string[]]$usersToSearchFor = "MilanStarcevic"
)

Import-Module .\PSGithubSearch.psm1

function SearchGitHub ($user) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $files = Find-GitHubCode -User $user -Keywords $keywordsToSearchFor
    foreach ($file in $files) {
        Write-Output "`t$($file.path)"
    }
}

function SearchAll () {  
    Write-Output "Started search for keywords: $($keywordsToSearchFor)" 
    foreach ($user in $usersToSearchFor) {
        Write-Output "Started search for user: $($user)"
        SearchGitHub $user
    }
}

SearchAll
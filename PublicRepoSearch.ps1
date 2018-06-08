param (
    [string[]]$keywordsToSearchFor = @("PublicRepoSearch", "identity", "suo"),
    [string[]]$githubUsersToSearchFor = "MilanStarcevic",
    [string[]]$bitbucketUsersToSearchFor = "MilanStarcevic"
)

Import-Module .\PSGithubSearch.psm1

function SearchGitHub () {
    Write-Output "GitHub search"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    foreach ($user in $githubUsersToSearchFor) {
        Write-Output "Started search for user: $($user)"
        
        $files = Find-GitHubCode -User $user -Keywords $keywordsToSearchFor
        foreach ($file in $files) {
            Write-Output "`t$($file.path)"
        }
    }
}

function SearchBitBucket () {
    Write-Output "Bitbucket search"

    foreach ($user in $bitbucketUsersToSearchFor) {
        Write-Output "Started search for user: $($user)"

        $searchQuery = $keywordsToSearchFor -join "+"
        
        $pageResponse  = Invoke-RestMethod -Uri "https://api.bitbucket.org/2.0/users/$user/search/code?search_query=$searchQuery"
        
        foreach ($value in $pageResponse.values) {
            Write-Output "`t$($value.file.links.self.href)"
        }
    }
}

function SearchAll () {  
    Write-Output "Started search for keywords: $($keywordsToSearchFor)" 
    
    SearchGitHub
    SearchBitBucket
}

SearchAll
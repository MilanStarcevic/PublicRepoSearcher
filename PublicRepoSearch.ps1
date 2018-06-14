param (
    [string[]]$keywordsToSearchFor = @("PublicRepoSearch"),
    [string]$githubUsername = "MilanStarcevic",
    [string]$githubPassword,
    [string[]]$bitbucketUsersToSearchFor = "MilanStarcevic"
)

function BasicAuthHeaders($username, $password) {
    $credPair = "$($username):$($password)"
    $encodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credPair))
    return @{ Authorization = "Basic $encodedCredentials" }
}

function SearchGitHub () {
    Write-Output "GitHub code search of all repositores"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $searchQuery = $keywordsToSearchFor -join "+"
    $response  = Invoke-RestMethod -Uri "https://api.github.com/search/code?q=$searchQuery" -Headers (BasicAuthHeaders $githubUsername $githubPassword)
    foreach ($item in $response.items) {
        Write-Output "`t$($item.html_url)"
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
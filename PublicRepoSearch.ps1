param (
    [string[]]$keywordsToSearchFor = @("test"),
    [string]$githubUsername = "MilanStarcevic",
    [string]$githubPassword,
    [string]$gitlabToken,
    [string[]]$bitbucketUsersToSearchFor = @("MilanStarcevic")
)

function BasicAuthHeaders($username, $password) {
    $credPair = "$($username):$($password)"
    $encodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credPair))
    return @{ Authorization = "Basic $encodedCredentials" }
}

function SearchGitHub () {
    if (!$githubPassword) {
        Write-Output "GitHub password is null. Skipping search on GitHub."
        return
    }

    Write-Output "GitHub code search of all repositores"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    foreach ($searchQuery in $keywordsToSearchFor) {
        $response  = Invoke-RestMethod -Uri "https://api.github.com/search/code?q=$searchQuery" -Headers (BasicAuthHeaders $githubUsername $githubPassword)
        Write-Output "`tGitHub search results for: $($searchQuery)"
        foreach ($item in $response.items) {
            Write-Output "`t`t$($item.html_url)"
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

function SearchGitLab () {
    if (!$gitlabToken) {
        Write-Output "GitLab private token is null. Skipping search on GitLab."
        return
    }

    Write-Output "GitLab code search of all snippet blobs"

    $searchQuery = $keywordsToSearchFor -join "+"
    $response  = Invoke-RestMethod -Uri "https://gitlab.com/api/v4/search?scope=snippet_blobs&search=$searchQuery" -Headers @{ "PRIVATE-TOKEN" = $gitlabToken }
    foreach ($item in $response) {
        Write-Output "`t$($item.web_url)"
    }
}

function SearchAll () {
    Write-Output "Started search for keywords: $($keywordsToSearchFor)"

    SearchGitHub
    SearchGitLab
    SearchBitBucket
}

SearchAll
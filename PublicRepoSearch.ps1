param (
    [string[]]$keywordsToSearchFor = "PublicRepoSearch"
)

function SearchGitHub () {
    Write-Output "Searching Git..."
    $UriBuilder = New-Object System.UriBuilder -ArgumentList 'https://api.github.com'
    $UriBuilder.Path = 'search/code' -as [uri]
    $UriBuilder.Query = $QueryString

    $BaseUri = $UriBuilder.Uri
    Write-Verbose "Constructed base URI : $($BaseUri.AbsoluteUri)"

    $Response = Invoke-WebRequest -Uri $BaseUri
    If ( $Response.StatusCode -ne 200 ) {

        Write-Warning "The status code was $($Response.StatusCode) : $($Response.StatusDescription)"
    }
    $NumberOfPages = Get-NumberofPage -SearchResult $Response
    Write-Verbose "Number of pages for this search result : $($NumberOfPages)"

    Foreach ( $PageNumber in 1..$NumberOfPages ) {

        $ResultPageUri = $BaseUri.AbsoluteUri + "&page=$($PageNumber.ToString())"

        Try {
            $PageResponse  = Invoke-WebRequest -Uri $ResultPageUri -ErrorAction Stop
        }
        Catch {
            Throw $_.Exception.Message
        }

        # The search API limits the number of requests to 10 requests per minute and per IP address (for unauthenticated requests)
        # We might be subject to the limit on the number of requests if we run function multiple times in the last minute
        $RemainingRequestsNumber = $PageResponse.Headers.'X-RateLimit-Remaining' -as [int]
        Write-Verbose "Number of remaining API requests : $($RemainingRequestsNumber)."

        If ( $RemainingRequestsNumber -le 1 ) {
            Write-Warning "The search API limits the number of requests to 10 requests per minute"
            Write-Warning "Waiting 60 seconds before processing the remaining result pages because we have exceeded this limit."
            Start-Sleep -Seconds 60
        }
        $PageResponseContent = $PageResponse.Content | ConvertFrom-Json

        Foreach ( $PageResult in $PageResponseContent.items ) {            

            $PageResult.psobject.TypeNames.Insert(0,'PSGithubSearch.Code')
            $PageResult
        }
    }
}

function SearchAll () {  
    Write-Output "Started search for keywords: " $keywordsToSearchFor
    SearchGitHub;
}

SearchAll
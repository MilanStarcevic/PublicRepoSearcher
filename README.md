# Public Repository Searcher

Searches through GitHub and Bitbucket public repositories for keywords. Perfect to detect sensitive data exposure.

## How to use?

You need PowerShell installed.

Call `.\PublicRepoSearch.ps1 -keywordsToSearchFor mycompanyname mycompanydomain -githubUsername someGuy -githubPassword somePassword -bitbucketUsersToSearchFor anoterGuy`.

| Parameter | Description | Example |
| ------------- |-------------| -----|
| keywordsToSearchFor | Array of strings that defines which keywords should be searched for in the public repositories | -keywordsToSearchFor mycompanyname mycompanydomain |
| githubUsername | The username of your GitHub account. Best to use an empty "service" account. | -githubUsername someGuy |
| githubPassword (*mandatory*) | The password of your GitHub account. | -githubPassword somePassword  |
| bitbucketUsersToSearchFor | The usernames of user's whose repositores you want to search on Bitbucket. Bitbucket API has a limitation that you can only search for code of specific user. | -bitbucketUsersToSearchFor anoterGuy |
# Public Repository Searcher

Searches through public code repositories for specified keywords. Perfect to detect sensitive data exposure.

Currently supported respositories:
* GitHub (all public repositories)
* GitLab (all snippets)
* Bitbucket (searchable repositories for specified users)

## How to use?

You need PowerShell installed.

Call `.\PublicRepoSearch.ps1 -keywordsToSearchFor mycompanyname mycompanydomain -githubUsername someone -githubPassword somePassword -bitbucketUsersToSearchFor another`.

| Parameter | Description | Example |
| ------------- |-------------| -----|
| keywordsToSearchFor | Array of strings that defines which keywords should be searched for in the public repositories | -keywordsToSearchFor "mycompanyname","mycompanydomain" |
| githubUsername | The username of your GitHub account. Best to use an empty "service" account. | -githubUsername "someone" |
| githubPassword | The password of your GitHub account. | -githubPassword "somePassword"  |
| gitlabToken | The private token created in your GitLab account. | -gitlabToken "someToken"  |
| bitbucketUsersToSearchFor | The usernames of user's whose repositores you want to search on Bitbucket. Bitbucket API has a limitation that you can only search for code of specific user. | -bitbucketUsersToSearchFor "anoter","yetAnother" |
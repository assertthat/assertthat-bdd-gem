## Description

Ruby gem for interaction with [AssertThat BDD Jira plugin](https://marketplace.atlassian.com/apps/1219033/assertthat-bdd-test-management-in-jira?hosting=cloud&tab=overview).

Main features are:

- Download feature files before test run
- Filter features to download based on mode (automated/manual/both), or/and JQL
- Upload cucumber json after the run to AsserTthat Jira plugin

## Installation

```
gem install assertthat-bdd
```

OR add to Gemfile

```
gem 'assertthat-bdd', '~> 1.0', '>= 1.6.4'
```

## Usage

### If using command line version

- For downloading features refer to usage below (one required parameter is projectId) 

```
assertthat-bdd-features -h

Usage: assertthat-bdd-features [options]
    --accessKey ACCESS_KEY       Access key same as env variable ASSERTTHAT_ACCESS_KEY
    --secretKey SECRET_KEY       Secret key same as env variable ASSERTTHAT_SECRET_KEY
    --token ASSERTTHAT_API_TOKEN  Jira API token (for DataCenter only) as an alternative to accessKey/secretKey basic auth
    --jiraServerUrl SERVER_URL   Jira Server URL (Only for jira server integration) e.g. https://mycompanyjira.com
    --projectId PROJECT_ID       Jira project id
    --outputFolder OUTPUT_FOLDER Featured output folder - default ./features
    --mode MODE                  Mode one of automated,manual,both - deafult automated
    --tags <tag-expression>      Cucucmber tag expression for scenarios filtering
    --jql JQL_FILTER             Jql issues filter
    --proxy PROXY_URL            proxy url to connect to Jira
    --help                       Show help
    --version                    Show version
```

- For submitting the report after the run ferer to usage below

```
assertthat-bdd-report -h

Usage: assertthat-bdd-report [options]
    --accessKey ACCESS_KEY       Access key same as env variable ASSERTTHAT_ACCESS_KEY
    --secretKey SECRET_KEY       Secret key same as env variable ASSERTTHAT_SECRET_KEY
    --token ASSERTTHAT_API_TOKEN  Jira API token (for DataCenter only) as an alternative to accessKey/secretKey basic auth
    --jiraServerUrl SERVER_URL   Jira Server URL (Only for jira server integration) e.g. https://mycompanyjira.com
    --projectId PROJECT_ID       Jira project id
    --runName RUN_NAME           The name of the run - default 'Test run dd MMM yyyy HH:mm:ss'
    --jsonReportFolder JSON_FOLDER_PATH,             Json report folder - default ./reports
    --jsonReportIncludePattern INCLUDE_REGEX,                Regex to search for cucumber reports - default .*.json
    --jql JQL_FILTER             Jql filtering of Jira tickets to update with test results
    --proxy PROXY_URL            proxy url to connect to Jira
    --help                       Show help
    --version                    Show version
```

### If using Rake

```ruby
require 'assertthat-bdd'

task :download_features do
 AssertThatBDD::Features.download(
    #Optional can be supplied as environment variable ASSERTTHAT_ACCESS_KEY
    accessKey:'ASSERTTHAT_ACCESS_KEY',
    #Optional can be supplied as environment variable ASSERTTHAT_SECRET_KEY
    secretKey:'ASSERTTHAT_SECRET_KEY',
    #Optional Jira API token (for DataCenter only) as an alternative to accessKey/secretKey basic auth
    token: 'ASSERTTHAT_TOKEN'  
    #Required for Jira Server only. Omit if using Jira Cloud version
    jiraServerUrl: 'https://mycompanyjira.com'
    #Required Jira project id e.g. 10001
    projectId: 'PROJECT_ID',
    #Optional - default ./features
    outputFolder: './features/',
    #Optional proxy url to connect to Jira
    proxy: 'PROXY_URL',
    #Optional - default automated (can be one of: manual/automated/both)
    mode: 'automated',
    #Optional - tag expression filter for scenarios. More on tag expressions https://cucumber.io/docs/cucumber/api/#tag-expressions
    tags: '(@smoke or @ui) and (not @slow)',
    #Optional - all features downloaded by default - should be a valid JQL
    jql: 'project = XX AND key in (\'XXX-1\')'
  ) 
end

task :upload_report do
 AssertThatBDD::Report.upload(
    #Optional can be supplied as environment variable ASSERTTHAT_ACCESS_KEY
    accessKey:'ASSERTTHAT_ACCESS_KEY',
    #Optional can be supplied as environment variable ASSERTTHAT_SECRET_KEY
    secretKey:'ASSERTTHAT_SECRET_KEY',
    #Optional Jira API token (for DataCenter only) as an alternative to accessKey/secretKey basic auth
    token: 'ASSERTTHAT_TOKEN' 
    #Required for Jira Server only. Omit if using Jira Cloud version
    jiraServerUrl: 'https://mycompanyjira.com'
    #Jira project id e.g. 10001
    projectId: 'PROJECT_ID',
    #The name of the run - default 'Test run dd MMM yyyy HH:mm:ss'
    runName: "Dry Tests Run",
    #Json report folder - default ./reports
    jsonReportFolder: "reports",
    #Regex to search for cucumber reports - default .*.json
    jsonReportIncludePattern: ".*/cucumber.json",
    #Optional - all issues will be updated by default - should be a valid JQL
    jql: 'project = XX AND key in (\'XXX-1\')'
  ) 
end
```

### Example project 

Refer to example project for running using Rake [assertthat-bdd-ruby-example](https://github.com/assertthat/assertthat-bdd-ruby-example)

[![Build Status](https://travis-ci.org/assertthat/assertthat-bdd-gem.svg?branch=master)](https://travis-ci.org/assertthat/assertthat-bdd-gem)

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
gem 'assertthat-bdd', '~> 1.0', '>= 1.0.2'
```

## Usage

### If using command line version

- For downloading features refer to usage below (one required parameter is projectId) 

```
assertthat-bdd-features -h

Usage: assertthat-bdd-features [options]
    -a, --accessKey ACCESS_KEY       Access key same as env variable ASSERTTHAT_ACCESS_KEY
    -s, --secretKey SECRET_KEY       Secret key same as env variable ASSERTTHAT_SECRET_KEY
    -p, --projectId PROJECT_ID       Jira project id
    -o, --outputFolder OUTPUT_FOLDER Featured output folder - default ./features
    -m, --mode MODE                  Mode one of automated,manual,both - deafult automated
    -j, --jql JQL_FILTER             Jql issues filter
    -x, --proxy PROXY_URL            proxy url to connect to Jira
    -h, --help                       Show help
    -v, --version                    Show version
```

- For submitting the report after the run ferer to usage below

```
assertthat-bdd-report -h

Usage: assertthat-bdd-report [options]
    -a, --accessKey ACCESS_KEY       Access key same as env variable ASSERTTHAT_ACCESS_KEY
    -s, --secretKey SECRET_KEY       Secret key same as env variable ASSERTTHAT_SECRET_KEY
    -p, --projectId PROJECT_ID       Jira project id
    -n, --runName RUN_NAME           The name of the run - default 'Test run dd MMM yyyy HH:mm:ss'
    -f JSON_FOLDER_PATH,             Json report folder - default ./reports
        --jsonReportFolder
    -i INCLUDE_REGEX,                Regex to search for cucumber reports - default .*.json
        --jsonReportIncludePattern
    -x, --proxy PROXY_URL            proxy url to connect to Jira
    -h, --help                       Show help
    -v, --version                    Show version
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
    #Required Jira project id e.g. 10001
    projectId: 'PROJECT_ID',
    #Optional - default ./features
    outputFolder: './features/',
    #Optional proxy url to connect to Jira
    proxy: 'PROXY_URL',
    #Optional - default automated (can be one of: manual/automated/both)
    mode: 'automated',
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
    #Jira project id e.g. 10001
    projectId: 'PROJECT_ID',
    #The name of the run - default 'Test run dd MMM yyyy HH:mm:ss'
    runName: "Dry Tests Run",
    #Json report folder - default ./reports
    jsonReportFolder: "reports",
    #Regex to search for cucumber reports - default .*.json
    jsonReportIncludePattern: ".*/cucumber.json"
  ) 
end
```

### Example project 

Refer to example project for running using Rake [assertthat-bdd-ruby-example](https://github.com/assertthat/assertthat-bdd-ruby-example)

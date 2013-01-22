# Dropbox Accounts Engine for Refinery CMS.


## About

Dropbox Accounts allows to to upload any files to Refinery CMS via Dropbox.


## Requirements

* refinerycms >= 2.0.0
* dropbox-api


## Features

* Any Refinery User can link his dropbox account (or accounts)
* Uses Dropbox Sandbox Api - Refinery only gets access to a single folder of the users dropbox (/Apps/<YOUR DROPBOX APP NAME>)
* Once the user adds a new file to that folder, you can sync all new files to Refinery CMS
* Gives you the ability to create custom file handler chains. See the examples for more details.


## Install

Add this line to your applications `Gemfile`
```ruby
gem 'refinerycms-dropbox_accounts', '~> 2.0.0', :git => 'https://github.com/apauly/refinery-dropbox_accounts'
```
Next run

```bash
bundle install
rails generate refinery:dropbox_accounts
rake db:migrate
```

This will generate a new file 'config/initializers/refinery/dropbox_accounts.rb' inside of your app directory.
Configure your Dropbox-App there. You will also find some instructions in how to setup some handlers.


## Sync
 
Call "rake refinery:dropbox_accounts:sync_all" or "Refinery::DropboxAccounts::DropboxAccount.sync_all(:batch_size => 50)" continously to get you up-to-date.
This can either be a cron, or anything else you prefer.


## TODOs
Currently, this gem only allows you to upload files. It doesn't handle any changes for a single file.

In the future there may be features like:
- download files & images to your dropbox
- automated backups
- updates / changes of a file (revision)
- lock a file to a certain revision
- restore of previous revisions
- add some localization
- prevent adding the same account twice (or more often ;))

Last but not least:
- This gem is still in development, some specs should to be added


## How to contribute
- Fork this project
- Add some specs, add $awesome_feature, create $cool_patch or do some refactoring
- Create a pull request
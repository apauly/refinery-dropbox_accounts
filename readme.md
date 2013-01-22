# Dropbox Accounts Engine for Refinery CMS.


## About

Dropbox Accounts allows you to upload any files to Refinery CMS via Dropbox.


## Requirements

* refinerycms >= 2.0.0
* dropbox-api


## Features

* Refinery Users can link their dropbox account (or even multiple accounts)
* Uses Dropbox Sandbox Api - Refinery CMS only gets access to a single folder of the users dropbox (/Apps/YOUR_DROPBOX_APP_NAME)
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

This will generate a new file ```config/initializers/refinery/dropbox_accounts.rb``` inside of your app directory.
Unless you haven't already, add the credentials for your Dropbox-App there.

## Adding Handlers
This Gem doesn't handle uploaded files in any way. You're the one who has to decide what to do with added files.
You can add several upload handlers inside of the just created initializer like this:

(Maybe you're interested in the ones creating Images and Resources)


```ruby
# set your Dropbox API credentials

Dropbox::API::Config.app_key    = "db_app_key"
Dropbox::API::Config.app_secret = "db_app_secret"
Dropbox::API::Config.mode       = "db_app_mode"


# Register all handlers inside of this file.
# The handlers you register here, will be processed from top to bottom.
# Once an exclusive handler is succesfully executed, the chain will stop executing.

# Most of your callbacks are called with an user (```Refinery::User```) and an item (either Dropbox::API::Dir or Dropbox::API::File)

# Possible options are: :if, :unless, :exclusive
Refinery::DropboxAccounts.register_item_handler({
  :if        => proc{|user, item| item.path.include?("skip-me") },
  :exclusive => true
}) do |user, item|

  # skip any items that contain 'skip-me' in their path.
  # the exclusive option ensures that no other handler is called

  # independant from that, returning false wil ensure that no recursive searches are executed
  false
end


# be careful with your constraints - there might be a file, you didn't expect.
# Like mime_type: 'image/x-icon'
Refinery::DropboxAccounts.register_item_handler({
  :if        => proc{|user, item| item.mime_type && item.mime_type.match(/x-icon/) },
  :exclusive => true
}) do |user, item|

  # do work here
  false
end


# :exclusive stops the chain if the item matches the handler.
Refinery::DropboxAccounts.register_item_handler({
  :if        => proc{|user, item| item.mime_type && item.mime_type.match(/image\/(jpeg|jpg|png)/) },
  :exclusive => true
}) do |user, item|

  Refinery::Image.new.tap do |img|
    img.image      = item.download
    img.image_name = item.path.split('/').last
    item.destroy if img.save
  end
end


# handle everything if nothing stopped the chain earlier.
# :if / :unless can also be symbols which are called directly on the dropbox item
Refinery::DropboxAccounts.register_item_handler :unless => :is_dir do |user, item|
  Refinery::Resource.new.tap do |file|
    file.file      = item.download
    file.file_name = item.path.split('/').last
    item.destroy if file.save
  end
end
```


## Sync
 
Call ```rake refinery:dropbox_accounts:sync_all``` or ```Refinery::DropboxAccounts::DropboxAccount.sync_all(:batch_size => 50)``` continously to get you up-to-date.
This can either be done inside of a cron, or anything else you prefer.


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

Some possible far, far future features:
- Don't know how workable it could be, but creating galleries/pages directly from your dropbox sounds kinda cool ;)

Last but not least:
- This gem is still in development, some specs should to be added


## How to contribute
- Fork this project
- Add some specs, add $awesome_feature, create $cool_patch or do some refactoring
- Create a pull request
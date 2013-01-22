module Refinery
  class DropboxAccountsGenerator < Rails::Generators::Base

    def rake_db
      rake("refinery_dropbox_accounts:install:migrations")
    end

    def create_initializer
      return if File.exists?(File.join(destination_root, 'config', 'initializers', 'refinery', 'dropbox_accounts.rb'))
      create_file 'config/initializers/refinery/dropbox_accounts.rb'
      append_file 'config/initializers/refinery/dropbox_accounts.rb', :verbose => true do
        
<<-EOH
# set your Dropbox API credentials

Dropbox::API::Config.app_key    = "db_app_key"
Dropbox::API::Config.app_secret = "db_app_secret"
Dropbox::API::Config.mode       = "db_app_mode"


# # Register all handlers inside of this file.
# # The handlers you register here, will be processed from top to bottom.
# # Once an exclusive handler is succesfully executed, the chain will stop executing.

# # Most of your callbacks are called with an user (Refinery::User) and an item (either Dropbox::API::Dir of Dropbox::API::File)

# # Possible options are: :if, :unless, :exclusive
# Refinery::DropboxAccounts.register_item_handler({
#   :if        => proc{|user, item| item.path.include?("skip-me") },
#   :exclusive => true
# }) do |user, item|

#   # skip any items that contain 'skip-me' in their path.
#   # the exclusive option ensures that no other handler is called

#   # independant from that, returning false wil ensure that no recursive searches are executed
#   false
# end



# # be careful with your constraints - there might be a file, you didn't expect.
# # Like mime_type: 'image/x-icon'
# Refinery::DropboxAccounts.register_item_handler({
#   :if        => proc{|user, item| item.mime_type && item.mime_type.match(/x-icon/) },
#   :exclusive => true
# }) do |user, item|

#   # do work here
#   false
# end


# # :exclusive stops the chain if the item matches the handler.
# Refinery::DropboxAccounts.register_item_handler({
#   :if        => proc{|user, item| item.mime_type && item.mime_type.match(/image\/(jpeg|jpg|png)/) },
#   :exclusive => true
# }) do |user, item|

#   Refinery::Image.new.tap do |img|
#     img.image      = item.download
#     img.image_name = item.path.split('/').last
#     item.destroy if img.save
#   end

# end

# # handle everything if nothing stopped the chain earlier.
# # :if / :unless can also be symbols which are called directly on the dropbox item
# Refinery::DropboxAccounts.register_item_handler :unless => :is_dir do |user, item|
#   Refinery::Resource.new.tap do |file|
#     file.file = item.download
#     file.file_name = item.path.split('/').last
#     item.destroy if file.save
#   end
# end

EOH
      end
    end

    def append_load_seed_data
      create_file 'db/seeds.rb' unless File.exists?(File.join(destination_root, 'db', 'seeds.rb'))
      append_file 'db/seeds.rb', :verbose => true do
        <<-EOH

# Added by Refinery CMS Dropbox Accounts extension
Refinery::DropboxAccounts::Engine.load_seed
        EOH
      end
    end
  end
end

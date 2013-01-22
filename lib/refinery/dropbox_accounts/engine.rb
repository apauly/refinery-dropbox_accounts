module Refinery
  module DropboxAccounts
    class Engine < Rails::Engine

      include Refinery::Engine
      isolate_namespace Refinery::DropboxAccounts

      engine_name :refinery_dropbox_accounts

      initializer "register refinerycms_dropbox_accounts plugin" do
        Refinery::Plugin.register do |plugin|

          plugin.name = "dropbox_accounts"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.dropbox_accounts_admin_dropbox_accounts_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/dropbox_accounts/dropbox_account',
            :title => 'created_at'
          }
        end

      end
      
      config.to_prepare do
        Refinery::User.send(:has_many, :dropbox_accounts, :class_name => 'Refinery::DropboxAccounts::DropboxAccount')
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::DropboxAccounts)
      end
    end
  end
end

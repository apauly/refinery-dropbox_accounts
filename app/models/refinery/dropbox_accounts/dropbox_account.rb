module Refinery
  module DropboxAccounts
    class DropboxAccount < Refinery::Core::BaseModel
      self.table_name = 'refinery_dropbox_accounts'

      attr_accessible :user_id, :token, :secret, :position

      acts_as_indexed :fields => [:token, :secret]

      validates :token, :presence => true, :uniqueness => true

      belongs_to :user

      module ClassMethods
        def sync_all(opts={})
          self.find_in_batches(opts) do |collection|
            collection.map(&:sync_files)
          end
        end

        def item_handler_exists?(name)
          #Refinery::DropboxAccounts.item_ahn
        end

        def dispatch_folder(user, folder)
        end

        # dispatches an item to the desired handlers.
        # returns an array of booleans which indicate if we should continue working on the handler chain
        def dispatch_item(user, item)
          Refinery::DropboxAccounts.item_handlers.map do |handler|
            next true unless handler.matches?(user, item)
            handler_result = handler.dispatch(user, item)
            return [false] if handler.exclusive?
            !! handler_result
          end
        end
      end

      extend ClassMethods

      module InstanceMethods
        def dropbox_client
          @dropbox_client ||= Dropbox::API::Client.new(
            :token  => self.token,
            :secret => self.secret
          )
        end

        def sync_files
          self.handle_folder_content(self.dropbox_client.ls)
        end

        def handle_folder_content(folder_content)
          folder_content.each do |item|
            if item.is_dir
              self.handle_folder_content(item.ls) if self.handle_item(item).all?
            else
              self.handle_item(item)
            end
          end
        end

        def handle_item(item)
          self.class.dispatch_item(self.user, item)
        end

      end
      include InstanceMethods

    end
  end
end
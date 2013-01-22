require 'refinerycms-core'

module Refinery
  autoload :DropboxAccountsGenerator, 'generators/refinery/dropbox_accounts_generator'

  module DropboxAccounts
    require 'refinery/dropbox_accounts/engine'

    module ClassMethods
      attr_accessor :item_handlers
      def register_item_handler(opts={}, &block)
        self.item_handlers ||= []
        self.item_handlers << ItemHandler.new(opts, block)
      end
    end
    extend ClassMethods

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end

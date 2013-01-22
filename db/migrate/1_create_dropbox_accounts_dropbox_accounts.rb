class CreateDropboxAccountsDropboxAccounts < ActiveRecord::Migration

  def up
    create_table :refinery_dropbox_accounts do |t|
      t.integer :user_id
      t.string :token
      t.string :secret
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-dropbox_accounts"})
    end

    drop_table :refinery_dropbox_accounts

  end

end

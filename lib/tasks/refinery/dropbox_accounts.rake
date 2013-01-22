namespace :refinery do

  namespace :dropbox_accounts do

    # Download all new files
    task :sync_all => :environment do
      Refinery::DropboxAccounts::DropboxAccount.sync_all(:batch_size => 20)
    end
    
  end

end
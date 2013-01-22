module Refinery
  module DropboxAccounts
    module Admin
      class DropboxAccountsController < ::Refinery::AdminController

        crudify :'refinery/dropbox_accounts/dropbox_account',
                :title_attribute => 'created_at',
                :xhr_paging      => true,
                :sortable        => false

        def index
          @dropbox_accounts = current_refinery_user.dropbox_accounts.paginate(:page => params[:page], :per_page => 10)
        end

        def new
          consumer                       = Dropbox::API::OAuth.consumer(:authorize)
          request_token                  = consumer.get_request_token
          session[:request_token]        = request_token.token
          session[:request_token_secret] = request_token.secret

          redirect_to request_token.authorize_url(:oauth_callback => refinery.callback_dropbox_accounts_admin_dropbox_accounts_url)
        end

        def callback
          consumer      = Dropbox::API::OAuth.consumer(:authorize)
          request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
          access_token  = request_token.get_access_token(:oauth_verifier => params[:oauth_token])

          dropbox_account = current_refinery_user.dropbox_accounts.build.tap do |u|
            u.token  = access_token.token
            u.secret = access_token.secret
          end

          if dropbox_account.save
            redirect_to refinery.dropbox_accounts_admin_dropbox_accounts_path, :notice => 'Succesfully linked your dropbox account'
          else
            redirect_to refinery.dropbox_accounts_admin_dropbox_accounts_path, :alert => 'There was an error linking your dropbox account'
          end
        end

        def destroy
          unless @dropbox_account.user == current_refinery_user
            redirect_to refinery.dropbox_accounts_admin_dropbox_accounts_path, :alert => 'Invalid Request'
          else
            if @dropbox_account.destroy
              flash[:notice] = "Successfuly destroyed dropbox account"
            else
              flash[:error] = "Failed to destroy dropbox account"
            end
            redirect_to refinery.dropbox_accounts_admin_dropbox_accounts_path
          end
        end

      end
    end
  end
end

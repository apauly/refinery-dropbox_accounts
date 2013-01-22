# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "DropboxAccounts" do
    describe "Admin" do
      describe "dropbox_accounts" do
        login_refinery_user

        describe "dropbox_accounts list" do
          before do
            FactoryGirl.create(:dropbox_account, :token => "UniqueTitleOne")
            FactoryGirl.create(:dropbox_account, :token => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.dropbox_accounts_admin_dropbox_accounts_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.dropbox_accounts_admin_dropbox_accounts_path

            click_link "Add New Dropbox Account"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Token", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::DropboxAccounts::DropboxAccount.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Token can't be blank")
              Refinery::DropboxAccounts::DropboxAccount.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:dropbox_account, :token => "UniqueTitle") }

            it "should fail" do
              visit refinery.dropbox_accounts_admin_dropbox_accounts_path

              click_link "Add New Dropbox Account"

              fill_in "Token", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::DropboxAccounts::DropboxAccount.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:dropbox_account, :token => "A token") }

          it "should succeed" do
            visit refinery.dropbox_accounts_admin_dropbox_accounts_path

            within ".actions" do
              click_link "Edit this dropbox account"
            end

            fill_in "Token", :with => "A different token"
            click_button "Save"

            page.should have_content("'A different token' was successfully updated.")
            page.should have_no_content("A token")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:dropbox_account, :token => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.dropbox_accounts_admin_dropbox_accounts_path

            click_link "Remove this dropbox account forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::DropboxAccounts::DropboxAccount.count.should == 0
          end
        end

      end
    end
  end
end

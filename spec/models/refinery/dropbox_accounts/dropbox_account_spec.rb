require 'spec_helper'

module Refinery
  module DropboxAccounts
    describe DropboxAccount do
      describe "validations" do
        subject do
          FactoryGirl.create(:dropbox_account,
          :token => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:token) { should == "Refinery CMS" }
      end
    end
  end
end

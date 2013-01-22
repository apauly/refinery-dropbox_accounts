
FactoryGirl.define do
  factory :dropbox_account, :class => Refinery::DropboxAccounts::DropboxAccount do
    sequence(:token) { |n| "refinery#{n}" }
  end
end


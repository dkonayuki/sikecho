PublicActivity::Activity.module_eval do

  #unread - read checking for public activity
  #need to increase size of readable_type collumn in unread table
  acts_as_readable on: :updated_at

end
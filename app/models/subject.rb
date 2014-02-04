class Subject < ActiveRecord::Base
  has_and_belongs_to_many :faculties
  has_and_belongs_to_many :notes
  has_and_belongs_to_many :teachers
  has_many :periods
  
  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
end
class Period < ActiveRecord::Base
  belongs_to :subject
  has_and_belongs_to_many :educations
  
  def self.day_names(day)
    %w(全て 月曜日 火曜日 水曜日 木曜日 金曜日 土曜日)[day]
  end
  
  def self.day_names_short(day)
    %w(全 月 火 水 木 金 土)[day]
  end
  
  def self.time_names(time)
    %w(全て 一時限 二時限 三時限 四時限 五時限 六時限 七時限 八時限)[time]
  end
  
  def self.time_names_short(time)
    %w(全 1 2 3 4 5 6 7 8)[time]
  end
  
  MAX_TIME = 7
  MAX_DAY = 6

end

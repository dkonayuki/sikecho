class Period < ActiveRecord::Base
  belongs_to :subject
  has_and_belongs_to_many :educations
  
  def self.day_names(day)
    %w(月曜日 火曜日 水曜日 木曜日 金曜日 土曜日)[day - 1]
  end
  
  def self.day_names_short(day)
    %w(月 火 水 木 金 土)[day - 1]
  end
  
  def self.time_names(time)
    %w(一時限 二時限 三時限 四時限 五時限 六時限 七時限 八時限)[time - 1]
  end
  
  def self.time_names_short(time)
    %w(1 2 3 4 5 6 7 8)[time - 1]
  end
  
  def self.MAX_TIME
    7
  end
  
  def self.MAX_DAY
    6
  end
end

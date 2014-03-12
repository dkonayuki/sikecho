module ApplicationHelper
  def save_file(user, filename, filedata)
    userpath = Rails.root.join("public","uploads",user.username)
    FileUtils.mkdir_p(userpath)
    path = File.join(userpath, filename)
    File.open(path,"wb") do |f|
      f.write(filedata.read)
    end
    path
  end
  
  def delete_file(path)
    File.delete(path)
  end
  
  def day_names(day)
    %w(月曜日 火曜日 水曜日 木曜日 金曜日 土曜日)[day]
  end
  
  def day_names_short(day)
    %w(月 火 水 木 金 土)[day]
  end
  
  def time_names(time)
    %w(一時限 二時限 三時限 四時限 五時限 六時限 七時限)[time]
  end
  
  def time_names_short(time)
    %w(1 2 3 4 5 6 7)[time]
  end
  
end

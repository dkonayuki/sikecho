module ApplicationHelper
  def save_file( user, filename ,filedata )
    userpath = Rails.root.join("public","uploads",user.username)
    FileUtils.mkdir_p(userpath)
    path = File.join(userpath, filename)
    File.open(path,"wb") do |f|
      f.write(filedata.read)
    end
    path
  end
  
  def delete_file( path )
    File.delete(path)
  end
end

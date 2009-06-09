class DataFile <  ActiveRecord::Base

  def self.open(filename, directory_path)
    f = File.open(directory_path+filename, 'r')
    return f
  end


  def self.save(upload, directory_path)
    name =  upload['datafile'].original_filename
    directory = directory_path
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end	
end

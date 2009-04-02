class DataFile < ActiveRecord::Base

 def self.save(upload, directory_path)
    name =  upload['datafile'].original_filename
    directory = directory_path
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end	
end

module LastSync
  LAST_SYNC_NORMAL_FILE = "#{Rails.root}/tmp/last_sync.txt"
  LAST_SYNC_TEST_FILE = "#{Rails.root}/tmp/last_sync_test.txt"
  LAST_SYNC_FILE = Rails.env == 'test' ? LAST_SYNC_TEST_FILE : LAST_SYNC_NORMAL_FILE 

  def self.get
    if !File.exists?(LAST_SYNC_FILE)
      set()
    end

    File.open(LAST_SYNC_FILE, "r") do |f|
      DateTime.iso8601(f.read)
    end
  end

  def self.set
    dir = File.dirname("#{Rails.root}/tmp")

    unless File.directory?(dir)
      FileUtils.mkdir_p(dir)
    end
    
    File.open(LAST_SYNC_FILE, "w+") do |f|
      f.write(DateTime.now)
    end
  end
end

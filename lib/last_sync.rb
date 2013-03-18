module LastSync
  LAST_SYNC_FILE = "#{Rails.root}/tmp/last_sync.txt"
  def self.get
    File.open(LAST_SYNC_FILE, "r") do |f|
      DateTime.iso8601(f.read)
    end
  end

  def self.set
    File.open(LAST_SYNC_FILE, "w") do |f|
      f.write(DateTime.now)
    end
  end
end

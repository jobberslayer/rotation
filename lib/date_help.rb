class DateHelp
  def self.today
    d = Time.now.to_a
    return [d[5], sprintf('%02d', d[4]), sprintf('%02d', d[3])]
  end

  def self.get_next_sunday
    d = Time.now.end_of_week.to_a
    return [d[5], sprintf('%02d', d[4]), sprintf('%02d', d[3])]
  end

  def self.previous_week(year, month, day)
    d = 1.week.ago(Time.new(year, month, day)).to_a
    return [d[5], sprintf('%02d', d[4]), sprintf('%02d', d[3])]
  end

  def self.next_week(year, month, day)
    d = -1.week.ago(Time.new(year, month, day)).to_a
    return [d[5], sprintf('%02d', d[4]), sprintf('%02d', d[3])]
  end
end

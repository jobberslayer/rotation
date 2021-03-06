class Formatters
  def self.volunteers(volunteers)
    if volunteers.empty?
      return '[Need to add volunteers]'
    end
    volunteers.map { |v| v.full_name }.join ', '
  end

  def self.date(year, month, day)
    "#{year}-#{month}-#{day}"
  end

  def self.formal_date(year, month, day)
    Time.new(year, month, day).strftime('%A, %B %d, %Y')
  end

  def self.date_time(dt)
    dt.strftime("%a, %b %d, %Y %I:%M:%S %p")
  end
end

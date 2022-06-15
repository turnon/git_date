require "git_date/version"
require "git_date/contiunuous_time"

module GitDate
  class << self
    def each
      ContinunousTime.new.each do |obj|
        yield obj.to_h
      end
    end
  end
end

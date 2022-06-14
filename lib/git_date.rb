require "git_date/version"
require "git_date/everytime"

module GitDate
  class << self
    def each
      Everytime.new.each do |obj|
        yield obj.to_h
      end
    end
  end
end

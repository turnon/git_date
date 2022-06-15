require 'git_date/everytime'
require 'git_date/time_point'

module GitDate
  class ContinunousTime
    include Enumerable

    def initialize
      @edge_name = TimePoint.edge_name
      @edge_format = TimePoint.edge_format
      @prev_method = TimePoint.prev_method

      @every_time = Everytime.new
    end

    def each
      current_time = @edge_format.call(Time.now)

      @every_time.each do |log|
        loop do
          break if current_time == log.time
          yield TimePoint.new(current_time)
          current_time = @prev_method.call(current_time)
        end

        yield log
        current_time = @prev_method.call(current_time)
      end
    end
  end
end

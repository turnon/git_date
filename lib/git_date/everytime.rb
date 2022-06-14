require 'time'
require 'git_date/git_log_name_status'
require 'git_date/time_point'

module GitDate
  class Everytime
    include Enumerable

    Edges = {
      'hour' => '%F %H:00:00',
      'day' => '%F',
      'week' => '%Y %U',
      'month' => '%Y-%m',
    }

    def initialize
      @edge = Edges[ENV['GITDAY_DURATION'] || 'day']
      @last = nil

      @enum = Enumerator.new do |e|
        GitLogNameStatus.new.each do |line|
          case line
          when /^Date/
            this_time = parse_time(line)
            next @last = TimePoint.new(this_time) if @last.nil?
            next if this_time == @last.time
            e << @last
            @last = TimePoint.new(this_time)
          when /^M\s+/
            @last.mod(line.sub(/^M\s+/, ''))
          when /^R[0-9]+\s/
          when /^A\s+/
            @last.add(line.sub(/^A\s+/, ''))
          end
        end
      end
    end

    def each
      @enum.each { |t| yield t }
      yield @last
    end

    private

    def parse_time(line)
      time_str = line.sub(/^Date:\s+/, '')
      Time.parse(time_str).strftime(@edge)
    end
  end
end

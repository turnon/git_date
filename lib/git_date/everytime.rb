require 'time'
require 'git_date/git_log_name_status'
require 'git_date/time_point'

module GitDate
  class Everytime
    include Enumerable

    ADD = /^A\s+/
    MOD = /^M\s+/
    DEL = /^D\s+/

    def initialize
      @edge = TimePoint.edge_format
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
          when MOD
            @last.mod(line.sub(MOD, ''))
          when /^R[0-9]+\s/
          when ADD
            @last.add(line.sub(ADD, ''))
          when DEL
            @last.del(line.sub(DEL, ''))
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
      @edge[Time.parse(time_str)]
    end
  end
end

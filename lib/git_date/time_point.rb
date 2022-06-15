require 'set'

module GitDate
  class TimePoint
    attr_reader :time

    ONE_HOUR = 60 * 60
    ONE_DAY = 24 * ONE_HOUR
    ONE_WEEK = 7 * ONE_DAY

    EDGES = {
      'hour' => ->(t){ Time.parse(t.strftime('%F %H:00:00')) },
      'day' => ->(t){ Time.parse(t.strftime('%F 00:00:00')) },
      'week' => ->(t){ Time.parse((t - ((t.wday - 1) * ONE_DAY)).strftime('%F 00:00:00')) },
      'month' => ->(t){ Time.parse(t.strftime('%Y-%m-01 00:00:00')) }
    }

    PREV = {
      'hour' => ->(t){ t - ONE_HOUR },
      'day' => ->(t){ t - ONE_DAY },
      'week' => ->(t){ t - ONE_WEEK },
      'month' => ->(t){ EDGES['month'][t - 1] }
    }

    class << self
      def edge_name
        Thread.current[:git_date_edge] || ENV['GIT_DATE_EDGE'] || 'day'
      end

      def edge_format
        EDGES[edge_name]
      end

      def prev_method
        PREV[edge_name]
      end
    end

    def initialize(time)
      @time = time
      @adds = Set.new
      @mods = Set.new
      @dels = Set.new
    end

    def mod(file)
      @mods << file unless @dels.include?(file)
    end

    def add(file)
      @mods.delete(file)

      if @dels.include?(file)
        @dels.delete(file)
      else
        @adds << file
      end
    end

    def del(file)
      @dels << file
    end

    def to_h
      {
        time: @time.strftime('%F %T'),
        adds_count: @adds.count,
        mods_count: @mods.count,
        dels_count: @dels.count,
      }
    end
  end
end

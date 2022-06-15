require 'set'

module GitDate
  class TimePoint
    attr_reader :time

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
        time: @time,
        adds_count: @adds.count,
        mods_count: @mods.count,
        dels_count: @dels.count,
      }
    end
  end
end

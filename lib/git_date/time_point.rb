require 'set'

module GitDate
  class TimePoint
    attr_reader :time

    def initialize(time)
      @time = time
      @adds = Set.new
      @mods = Set.new
    end

    def mod(file)
      @mods << file
    end

    def add(file)
      @mods.delete(file)
      @adds << file
    end

    def to_h
      {time: @time, adds_count: @adds.count, mods_count: @mods.count}
    end
  end
end

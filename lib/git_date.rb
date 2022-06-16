require "git_date/version"
require "git_date/continunous_time"

module GitDate
  class << self
    def list(**opt)
      List.new(**opt)
    end
  end

  class List
    def initialize(**opt)
      Thread.current[:git_date_edge] = opt[:edge] || ENV['GIT_DATE_EDGE'] || 'day'
      Thread.current[:git_date_repo] = opt[:repo] || ENV['GIT_DATE_REPO'] || '.'
      Thread.current[:git_date_since] = opt[:since] || ENV['GIT_DATE_SINCE']

      @list = ContinunousTime.new
    end

    def each
      @list.each{ |log| yield log.to_h }
    end
  end
end

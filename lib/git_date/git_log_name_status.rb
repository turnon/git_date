module GitDate
  class GitLogNameStatus
    include Enumerable

    def initialize
      @enum = Enumerator.new do |e|
        repo = Thread.current[:git_date_repo]
        `git -C #{repo} log --name-status`.each_line do |line|
          e << line
        end
      end
    end

    def each
      @enum.each do |line|
        yield line
      end
    end
  end
end

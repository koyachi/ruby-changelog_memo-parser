module ChangelogMemo
  class Entry
    attr_accessor :title, :body, :tags, :create_date

    def initialize(title, body, tags, create_date)
      @title = title
      @body = body
      @tags = tags
      @create_date = create_date
    end

    def==(other)
      @title == other.title &&
      @body == other.body &&
      @tags == other.tags &&
      @create_date == other.create_date
    end
  end
end

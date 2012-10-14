module ChangelogMemo
  module Parser
    class << self
      def parse_file(path)
        parse_text(open(path).readlines.join(""))
      end

      def parse_text(text)
        daily_entries(text).map do |daily_entry|
          entries(daily_entry).map do |e|
            ChangelogMemo::Entry.new(
              e[:title],
              e[:body],
              e[:tags],
              [daily_entry[:year], daily_entry[:month], daily_entry[:day]].join('-')
              )
          end
        end.flatten
      end

      private
      def daily_entries(text)
        org_text = text
        offset = 0
        total_offset = 0
        total_length = text.length
        results = []
        prev_day = nil
        while total_offset < text.length
          re = /^((?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2}) \(.*?\)  (?<author>.*?)  <(?<email>.*?)>)/
          md = re.match(text)
          break if md.nil?
          break unless md[:year] and md[:month] and md[:day]

          current_day = {
            :year => md[:year],
            :month => md[:month],
            :day => md[:day],
            :author => md[:author],
            :email => md[:email],
            :search_offset => offset,
            :offset => total_offset + md.begin(:year),
            :length => 0,
            :text => nil
          }
          if prev_day
            prev_day[:length] = current_day[:offset] - prev_day[:offset]
            extract_text(org_text, prev_day)
          end
          results.push(current_day)
          offset = md.end(:email) + 2
          total_offset += offset
          text = text[offset..-1]
          prev_day = results[-1]
        end
        prev_day[:length] = total_length
        extract_text(org_text, prev_day)
        results
      end

      def extract_text(text, daily_entry)
        daily_entry[:text] = text[daily_entry[:offset], daily_entry[:length]]
      end

      def entries(daily_entry)
        entries = daily_entry[:text].split("\n\n")[1..-1]
        entries.map do |entry_text|
          re = /\A\t\* (?<tags>.*?):\s*(?<title>.*?)\n\t(?<body>.*?)\Z/m
          md = re.match(entry_text)
          entry = {
            :title => md[:title],
            :tags => md[:tags].split(',').map { |t| t.strip },
            :body => md[:body].split("\n\t").join("\n")
          }
          entry
        end
      end
    end
  end
end

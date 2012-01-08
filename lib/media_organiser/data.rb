module MediaOrganiser
  class Data
    class << self
      DOWNCASE_WORDS = %w(a an at ep in of the to vol vs with)
      UPCASE_WORDS   = %w(cd1 cd2 cd3 csi ii iii iv la ncis vi vii)

      def get_title(str)
        m = str.match /(?<title>.+?)(?:[\(\)\-\[\]]|CD\s?\d{1}|(?:brrip|dvdrip|hdtv|r5|xvid)|\.(?:19|20)\d{2}|S\d{2}|\d{1,2}x\d{1,2})/i
        m ? format_string(m[:title]) : format_string(str.gsub(::File.extname(str), ''))
      end

      def get_cd(str)
        m = str.match /CD\s?(?<cd>\d{1,2})/i
        m ? "CD#{m[:cd].to_i}" : nil
      end

      def get_year(str, ret_nil=false)
        m = str.match(/.+\(?(?<year>(?:19|20)\d{2})\)?/)
        m ? m[:year] : (ret_nil || str =~ /trilogy|series|compilation/i ? nil : 'UNKNOWN_YEAR')
      end

      def get_season(str)
        m = str.match(/S(?<season>\d{1,2})|(?<season>\d{1,2})x\d{2}/i)
        m ? m[:season].rjust(2, '0') : 'UNKNOWN_SEASON'
      end

      def get_episode(str)
        m = str.match(/E(?<episode>\d{2})|\d{1,2}x(?<episode>\d{2})/i)
        m ? m[:episode].rjust(2, '0') : 'UNKNOWN_EPISODE'
      end

      def get_resolution(str)
        m = str.match(/(720|1080)p/)
        m ? m[0] : nil
      end

      private
        def format_string(*strs)
          words = strs.join(' ').gsub(/\.|_/, ' ').downcase.split(/\s/)

          words.map do |word|
            if DOWNCASE_WORDS.include?(word) && words.first != word
              word.downcase!
            elsif UPCASE_WORDS.include?(word)
              word.upcase!
            else
              word.capitalize!
            end
          end

          words.join(' ')
        end
    end
  end
end
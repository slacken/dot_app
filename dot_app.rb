require 'open-uri'
require 'chinese_pinyin'

class DotApp
  SERVER = 'https://www.registry.google/whois/'.freeze

  class << self
    # look up domain
    def lookup(name)
      url = [SERVER, name, '.app'].join
      begin
        content = open(url){|f| f.read}
        info = content.split(/[\r\n]+/).map{|i| i.split(": ")}.select{|i| i.size == 2}
        Hash[info]
      rescue OpenURI::HTTPError => e
        nil
      end
    end

    def danpin
      pins = File.read(File.dirname(__FILE__) + '/data/danpin.txt').split(",")
      words = pins + pins.zip(pins).map(&:join)
      select('danpin', words.map{|w| {en: w}})
    end

    def webdict
      dir = File.dirname(__FILE__) + '/data/webdict_with_freq.txt'
      words = File.read(dir).strip.split("\n").map{|line| 
          l = line.split(" ")
          [l[0], l[1].to_i]
        }.select{|l| 
          l[0].size<=2 && l[1]>=10
        }.sort_by{|l| -l[1]}

      select('webdict', words.map{|l| {cn: l[0], no: l[1], en: pinyin(l[0])} })
    end

    # 
    def select(type, options)
      file = File.open("#{File.dirname(__FILE__)}/store_#{type}.txt", 'w+')
      begin
        counter = 0
        options.each do |opt|
          if lookup(opt[:en])
            print '.'
          else
            info =  ["#{opt[:en]}.app", opt[:cn], opt[:no]].reject{|i| i.nil?}.join(",")
            file.puts(info)
            print "\n#{info}\n"
            file.flush if (counter+=1)%100 == 0
          end
        end
      rescue StandardError => e
        file.close
        raise e
      end
    end

    def pinyin(word)
      Pinyin.t(word, splitter: '')
    end
  end
end
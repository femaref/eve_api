module EveApi
  module Parsers
    class Cache
      def initialize(result)
        @document = result.is_a?(Nokogiri::XML::Document) ? result : Nokogiri::XML(result)
      end
      
      def parse
        cached_until = Time.parse(@document.css("cachedUntil").first.inner_text + " UTC")
        current_time = Time.parse(@document.css("currentTime").first.inner_text + " UTC")
        
        return [cached_until, current_time]
      end
    end
  end
end
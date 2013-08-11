module EveApi
  module Caches
    class File < Default
      def initialize(cache_path)
        @root = cache_path
      end
      
      def cached?(keyID, scope, canonic_name, characterID)
        file_path = render_path(keyID, scope, canonic_name, characterID)
        
        return false if !::File.exists?(file_path)
        
        cached = ::File.open(file_path) do |f|
          parser = EveApi::Parsers::Cache.new(f.read)
          
          cached_until, _ = parser.parse
          
          Time.now <= cached_until
        end
        
        return cached
      end
      
      def retrieve(keyID, scope, canonic_name, characterID)
        rendered_path = render_path(keyID, scope, canonic_name, characterID)
        
        if cached?(keyID, scope, canonic_name, characterID)
          return ::File.open(rendered_path) do |f|
            f.read
          end
        else
          return nil
        end
      end
      
      def store!(keyID, scope, canonic_name, characterID, content)
        rendered_path = render_path(keyID, scope, canonic_name, characterID)
        
        FileUtils.mkdir_p(::File.dirname(rendered_path))
        
        ::File.open(rendered_path, "w+") do |f|
          f.write(content.to_s)
        end
        
        return true
      end
      
      private
      
      def render_path(keyID, scope, canonic_name, characterID)
        rendered_path = path(keyID, scope, canonic_name, characterID)
        
        return ::File.join(@root, rendered_path)
      end
      
    end
  end
end
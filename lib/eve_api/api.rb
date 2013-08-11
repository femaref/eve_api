module EveApi
  class Api
    BASE_URI = "https://api.eveonline.com"
  
    def initialize(keyID, vCode)
      @keyID = keyID
      @vCode = vCode
    end
    
    def account
      ScopedApi.new(@keyID, @vCode, :account)
    end
    
    def char
      ScopedApi.new(@keyID, @vCode, :char)
    end
    
    def corp
      ScopedApi.new(@keyID, @vCode, :corp)
    end
    
    def eve
      ScopedApi.new(@keyID, @vCode, :eve)
    end
    
    def map
      ScopedApi.new(@keyID, @vCode, :map)
    end    
    
    def server
      ScopedApi.new(@keyID, @vCode, :map)
    end
    
    def self.canonic_path(path)
      path.to_s.downcase.split("_").map{ |m| m.capitalize }.reduce(:+)
    end
    
    def self.uri(path, scope)
      scope_uri = Addressable::URI.parse("/#{scope.to_s}/")
      
      path_capitalized = self.canonic_path(path)
      path_capitalized += ".xml.aspx"
      
      path_uri = Addressable::URI.parse(path_capitalized)
      
      final_uri = scope_uri + path_uri
      
      return final_uri
    end
    
    protected
        
    def call(path, scope, args)
      canonic_name = self.class.canonic_path(path)
      uri = self.class.uri(path, scope)
      args = args.merge({ :keyID => @keyID, :vCode => @vCode })
      
      characterID = (args[:characterID] || args[:character_id] || 0)
      
      if cache = EveApi.cache.retrieve(@keyID, scope, canonic_name, characterID)
        document= Nokogiri::XML(cache)
      else
        @connection ||= Faraday.new(:url => BASE_URI) do |faraday|
          faraday.request :url_encoded
          faraday.response :logger
          faraday.adapter Faraday.default_adapter
        end
      
        result = @connection.get uri, args
      
        if result.status != 200
          raise "Status Code not equal 200"
        end
        
        cache = result.body
        EveApi.cache.store!(@keyID, scope, canonic_name, characterID, cache)
        
        document = Nokogiri::XML(cache)
      end
      
      EveApi::Parsers::Default.new(canonic_name, document).parse   
    end
  end
end
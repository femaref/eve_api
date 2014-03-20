module EveApi
  class Crest
    BASE_URI = "https://public-crest.eveonline.com"
  
    attr_accessor :cache_only, :path
  
    def initialize(path, cache_only = false)
      self.path = path
      self.cache_only = cache_only
    end
  
    def call(opt = {})
      splat = render(opt)
    
      conn = Faraday.new(:url => BASE_URI) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    
      response = conn.get("/#{splat.join('/')}/")
    
      case response.status
        when 200
          return JSON.parse(response.body)
        when 404
          raise EAAL::Exception::APINotFoundError.new("The requested API (#{splat}) could not be found.")
        else
          raise EAAL::Exception::HTTPError.new("An HTTP Error occured, body: " + response.body)
      end
    end
  
    private 
  
    def render(opt)
      result = self.path.map do |m|
        if m.is_a?(Symbol)
          if !opt.has_key?(m)
            raise "could not find :#{m} in argument"
          end
        
          res = opt[m].to_s
        else
          res = m if m.is_a?(String)
        end
      
        res
      end
  
      return result
    end
  end
end
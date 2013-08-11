module EveApi
  class ScopedApi < Api
    def initialize(keyID, vCode, scope)
      @scope = scope
      super(keyID, vCode)
    end
    
    def method_missing(method, args = {})      
      self.call(method, @scope, args)
    end
  end
end
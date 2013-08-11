module EveApi
  module Caches
    class Default
      def initialize
      end
    
      def path(keyID, scope, canonic_name, characterID)
        "#{keyID}/#{scope}/#{canonic_name}/#{characterID}"
      end
      
      def cached?(keyID, scope, canonic_name, characterID)
        return false
      end
      
      def retrieve(keyID, scope, canonic_name, characterID)
        return nil
      end
      
      def store!(keyID, scope, canonic_name, characterID, content)
        return false
      end
    end
  end
end
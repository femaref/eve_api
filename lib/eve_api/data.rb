module EveApi  
  module Data
    class Generic
      def initialize(data)
        @data = data
      end
      
      def method_missing(name, *args)
        if !@data.has_key?(name.to_sym)
          return super
        end
        
        return @data[name.to_sym]
      end
      
      def keys
        @data.keys
      end
      
      def inspect
        "<# EveApi::Data::Generic keys: #{keys} >"
      end
      
      def to_hash
        @data.dup
      end
    end
  
    class Result < Generic
      attr_accessor :current_time, :cached_until, :outdated      
     
      def initialize(current_time, cached_until, data, outdated = false)
        @current_time = current_time
        @cached_until = cached_until
        @outdated = outdated
        super(data)
      end
    end
    
    class Rowset
      include Enumerable
      extend Forwardable
      
      def_delegator :@rows, :each, :each
    
      def initialize(rows)          
        @rows = rows
      end
      
      def to_a
        @rows.dup
      end
    end
    
    class Row < Generic
    end
      
    def self.result(canonic_name)
      name = "#{canonic_name}Result".to_sym
      
      if const_defined?(name)
        return const_get name
      end
      
      klass = Class.new(Result)
            
      const_set name, klass
      
      return klass
    end
  
    def self.rowset(canonic_name, keys, fields = [])
      name = "#{canonic_name}Rowset".to_sym
      if const_defined?(name)
        return const_get name
      end
      
      klass = Class.new(Rowset)
      
      klass.const_set("NAME", canonic_name)
      klass.const_set("FIELDS", fields)
      klass.const_set("KEYS", keys)
      
      const_set name, klass
      
      return klass
    end
    
    def self.row(canonic_name, keys, fields = [])
      name = "#{canonic_name}Row".to_sym
      if const_defined?(name)
        return const_get name
      end
      
      klass = Class.new(Row)
      
      klass.const_set("NAME", canonic_name)
      klass.const_set("FIELDS", fields)
      klass.const_set("KEYS", keys)
      
      const_set name, klass
      
      return klass
    end
  end
end
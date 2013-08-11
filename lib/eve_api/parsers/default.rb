module EveApi
  module Parsers
    class Default < Cache
      STRING_DETECTION = /[^\d.]+/
    
      def initialize(canonic_name, result)
        @canonic_name = canonic_name
        super(result)
      end
    
      def parse
        rowsets = @document.css("result > rowset").map do |rowset|
          parsed = parse_rowset(rowset) 
          [ parsed.class::NAME.downcase.to_sym, parsed ]
        end
        
        cached_until, current_time = super
        
        result_klass = EveApi::Data.result(@canonic_name)
        
        data = rowsets
        
        single_fields = @document.css("result > *").select do |node|
          node.name != "rowset"
        end
        
        single_fields = single_fields.map do |node|
          parse_node(node)
        end
        
        data += single_fields
        
        data = Hash[data]
        
        result_klass.new(current_time, cached_until, data)
      end
      
      private
      
      def parse_rowset(data)
        fields = data.attribute("columns").value.split(",")
        keys = data.attribute("key").value.split(",")
        name = data.attribute("name").value.capitalize
        
        rowset_klass = EveApi::Data.rowset(name, keys, fields)
        
        rows = data.css("> row").map do |row|
          parse_row(name, keys, fields, row)
        end
        
        rowset_klass.new(rows)
      end
      
      def parse_row(rowset_name, keys, fields, data)
        row_klass = EveApi::Data.row(rowset_name, keys, fields)
        
        ary = data.map do |k, v|
          [k.to_sym, parse_attribute(k, v)]
        end
        
        hash = Hash[ary]
        
        row_klass.new(hash)
      end
      
      def parse_attribute(key, value)
        sym_key = key.to_sym
        
        if value == nil || value == ""
          return EveApi.default_for_empty
        end
      
        if sym_key == :date
          return Time.parse(value)
        end
        
        if key.downcase.include?("singleton")
          return value == "1"
        end
        
        if self.class::STRING_DETECTION.match(value) 
          return value
        end
        
        value = value.to_f
        
        if value.to_i == value
          return value.to_i  
        end
         
        return value
      end
      
      def parse_node(node)
        if node.children.count == 0
          return [node.name.to_sym, nil ]
        end
      
        if node.children.count == 1 && node.children.first.text?
          return [node.name.to_sym, parse_attribute(node.name, node.inner_text)]
        end
        
        return [ node.name.to_sym, EveApi::Data::Generic.new(Hash[node.css(" > *").map{ |m| parse_node(m) }]) ]
      end
    end
  end
end
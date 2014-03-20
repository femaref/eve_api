require 'eve_api/version'
require 'addressable/uri'
require 'faraday'
require 'nokogiri'
require 'json'

module EveApi

  autoload :Crest, 'eve_api/crest.rb'
  autoload :Api, 'eve_api/api.rb'
  autoload :ScopedApi, 'eve_api/scoped_api.rb'
  
  autoload :Data, 'eve_api/data.rb'
  
  module Parsers
    autoload :Default, 'eve_api/parsers/default.rb'
    autoload :Cache, 'eve_api/parsers/cache.rb'
  end
  
  module Caches
    autoload :Default, 'eve_api/caches/default.rb'
    autoload :File, 'eve_api/caches/file.rb'
  end
  
  def self.cache
    @cache
  end
  
  def self.cache=(value)
    @cache = value
  end
  
  def self.default_for_empty
    @default_for_empty
  end
  
  def self.default_for_empty=(value)
    @default_for_empty = value
  end
   
  @cache ||= EveApi::Caches::Default.new
  @default_for_empty = nil
end

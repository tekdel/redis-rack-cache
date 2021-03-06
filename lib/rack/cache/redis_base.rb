require 'rack/utils'

module Rack
  module Cache
    module RedisBase
      def self.included(base)
        base.extend ClassMethods
        base.instance_eval do
          extend Rack::Utils

          attr_reader :cache, :options, :default_ttl
        end
      end

      module ClassMethods
        def resolve(uri)
          new ::Redis::Store::Factory.resolve(uri.to_s)
        end
      end

      def initialize(server, options = {})
        @cache = ::Redis::Store::Factory.create(server)
        @options = options
        @default_ttl = options[:default_ttl] || ::Redis::Rack::Cache::DEFAULT_TTL
      end

      def open(key)
        data = read(key)
        data && [data]
      end
    end
  end
end

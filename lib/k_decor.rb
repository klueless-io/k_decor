# frozen_string_literal: true

require 'k_log'
require 'k_type'

require 'k_decor/version'
require 'k_decor/base_decorator'
require 'k_decor/resolve_instance'
require 'k_decor/configuration'
require 'k_decor/decorator_hash'
require 'k_decor/helper'

module KDecor
  # raise KDecor::Error, 'Sample message'
  class Error < StandardError; end

  class << self
    attr_accessor :decorate

    def configuration
      @configuration ||= KDecor::Configuration.new
    end

    def reset
      @configuration = KDecor::Configuration.new
    end

    def configure
      yield(configuration)
    end
  end

  KDecor.decorate = KDecor::Helper.new
end

if ENV['KLUE_DEBUG']&.to_s&.downcase == 'true'
  namespace = 'KDecor::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('k_decor/version') }
  version   = KDecor::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end

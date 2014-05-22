require 'haml'
require 'meta_tags'
require 'simple_form'
require 'foreigner'
require 'sidekiq'
require 'sidekiq/exception_handler'
require 'sidetiq'
require 'httparty'
require 'kaminari'
require 'kaminari-bootstrap'
require 'css_class_list'

module Wow
  class Engine < ::Rails::Engine
    # isolate_namespace Wow
  end
end

require 'wow/battle_net/api_client'

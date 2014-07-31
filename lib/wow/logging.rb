module Wow
  module Logging

    def log(event_code, message, options={})
      Rails.logger.info "#{event_code}: #{message}"
      if options[:publish]
        ActiveSupport::Notifications.instrument event_code, message: message
      end
    end
  end
end

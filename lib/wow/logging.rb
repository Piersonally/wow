module Wow
  module Logging

    LOG_LEVELS = [:debug, :info, :alert]

    def log(event_code, message, options={})
      log_level = options[:log_level] || :info
      Rails.logger.info "#{event_code}: #{message}"
      if options[:publish]
        ActiveSupport::Notifications.instrument event_code,
                                                message: message,
                                                log_level: log_level
      end
    end
  end
end

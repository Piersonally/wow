RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller

  config.before(type: :controller) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
end



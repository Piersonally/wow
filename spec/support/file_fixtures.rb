module FileFixtures
  def fixture_file_path(filename)
    Rails.root.join *%w[spec fixtures files], filename
  end
end

RSpec.configure do |config|
  config.include FileFixtures
end

require 'mumukit'

Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-hspec-worker'
  config.runner_name = 'hspec-server2'
end

require_relative './haskell_file_hook'
require_relative './expectations_hook'
require_relative './validation_hook'
require_relative './metadata_hook'
require_relative './test_hook'
require_relative './query_hook'

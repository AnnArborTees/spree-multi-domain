# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'ffaker'
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f }

# Requires factories defined in spree_core
require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'

require 'spree/api/testing_support/caching'
require 'spree/api/testing_support/helpers'
require 'spree/api/testing_support/setup'

require 'spree_multi_domain/factories'
require 'sunspot_matchers'

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::Api::TestingSupport::Helpers, :type => :controller
  config.extend Spree::Api::TestingSupport::Setup, :type => :controller
  config.include AjaxHelpers
  config.include AuthenticationHelpers
  config.include StoreHelpers
  config.include SunspotMatchers

  #config.include ControllerHacks, type: :controller

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.before do
    Spree::Api::Config[:requires_authentication] = true
    Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::ControllerRequests


  config.deprecation_stream = 'log/rspec-deprecations.log'

end

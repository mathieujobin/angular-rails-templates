# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

# Remove tmp dir of dummy app before it's booted.
FileUtils.rm_rf "#{File.dirname(__FILE__)}/dummy/tmp"

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'minitest/autorun'
require 'capybara/rails'
require 'active_support/core_ext/kernel/reporting'

if Rails.version > '5'
  require 'coveralls'
  Coveralls.wear!
end

# Hack to run tests with Rails 4.2 and Ruby 2.6
if RUBY_VERSION >= '2.6.0'
  if Rails.version < '5'
    # rubocop:disable Style/CommentAnnotation
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
    # rubocop:enable Style/CommentAnnotation
  end
end

Rails.backtrace_cleaner.remove_silencers!

# Support MiniTest 4/5
Minitest::Test = MiniTest::Unit::TestCase unless defined? Minitest::Test

class IntegrationTest < MiniTest::Spec
  include Capybara::DSL
  register_spec_type(/integration$/, self)
end

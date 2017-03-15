module SpecTestHelper
  def add_session(arg)
    session = {}
    arg.each { |k, v|
      session.store(k, v)
    }
  end
end

RSpec.configure do |config|
  config.include SpecTestHelper, type: :controller
end
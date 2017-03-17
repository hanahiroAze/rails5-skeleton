module SpecTestHelper
  def add_session(arg)
    session = {}
    arg.each { |k, v|
      session.store(k, v)
    }
  end

  def login(user)
    user = User.where(:id => user.id).first if user.is_a?(Symbol)
    request.session[:user] = user.id
  end

  def current_user
    User.find(request.session[:user])
  end
end

RSpec.configure do |config|
  config.include SpecTestHelper, type: :controller
end
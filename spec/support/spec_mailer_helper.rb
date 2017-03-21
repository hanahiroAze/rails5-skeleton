module SpecMailerHelper
  def create_user(user_params)
    User.with_writable { User.new(user_params).save }
  end
end

RSpec.configure do |config|
  config.include SpecMailerHelper, type: :mailer
end
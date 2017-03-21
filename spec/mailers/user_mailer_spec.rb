require 'spec_helper'

RSpec.describe UserMailer, type: :mailer do
  before do
    create_user({
      name: 'test',
      email: 'test@testtest.com',
      password: 'rails5',
      password_confirmation: 'rails5'}
    )
    @user = User.first
  end

  it 'reset mail' do
    @user.create_reset_digest
    mail = @user.send_password_reset_email
    expect(mail.subject).to eq 'Password Reset'
    expect(mail.to.first).to eq 'test@testtest.com'
  end
end
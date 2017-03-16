require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  before do
    User.with_writable {User.create(name: 'test', email: 'test@testtest.com', password: 'rails5', password_confirmation: 'rails5')}
  end

  describe 'Login' do
    it 'login success' do
      login User.first
      expect(response).to have_http_status(200)
    end
  end

  describe 'Logout' do
    before do
      login User.first
    end

    it 'logout success' do
      post :destroy
      expect(response).to have_http_status(302)
    end
  end
end

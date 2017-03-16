require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:test_user_param) do
    {
        params:{
            user: {
                name: 'test',
                email: 'test@testtest.com',
                password: 'rails5',
                password_confirmation: 'rails5'
            }
        }
    }
  end

  describe "POST success User::create" do
    it 'create user' do
      expect {
        post :create, test_user_param
      }.to change(User, :count).by(1)
    end
  end

  describe 'After Login' do
    before do
      post :create, test_user_param
      login User.first
    end
    it 'create user' do
      get :edit, {:params => {:id => User.first.id} }
      expect(response).to have_http_status(200)
    end
  end
end

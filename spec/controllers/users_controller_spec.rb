require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "POST success User::create" do
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
    it 'create user' do
      expect {
        post :create, test_user_param
      }.to change(User, :count).by(1)
    end
  end
end

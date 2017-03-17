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
      @user = User.first
      login @user
    end

    it 'edit user index' do
      get :edit, {:params => {:id => @user.id} }
      expect(response).to have_http_status(200)
    end

    it 'edit user email error' do
      patch :update, {
        :params => {
          :id => @user.id,
          user: {
            name: 'test',
            email: 'test2nd.com',
            password: '',
            password_confirmation: ''
          }
        }
      }
      expect(response).to have_http_status(200)
      expect(response.body).not_to include('error')
    end

    it 'edit user email success' do
      patch :update, {
          :params => {
              :id => @user.id,
              user: {
                  name: 'test',
                  email: 'test@2nd.com',
                  password: '',
                  password_confirmation: ''
              }
          }
      }
      expect(response).to have_http_status(302)
      @user.reload
      expect(@user.email).to eq('test@2nd.com')
    end
  end

  describe 'edit other user' do
    let(:test_login_user_param) do
      {
          params:{
              user: {
                  name: 'test',
                  email: 'test2@testtest.com',
                  password: 'rails5',
                  password_confirmation: 'rails5'
              }
          }
      }
    end

    it 'not allowed' do
      post :create, test_user_param
      post :create, test_login_user_param
      @user = User.first
      @test_login_user_param = User.second
      login @test_login_user_param
      get :edit, {params: {id: @user.id}}
      expect(response).to have_http_status(302)
    end
  end

  describe 'show all user' do
    it 'not arrowed' do
      get :index
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(login_path)
    end
  end
end

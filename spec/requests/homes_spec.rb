require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET Access" do
    it "index" do
      get "/"
      expect(response).to have_http_status(200)
    end

    it "about" do
      get "/about"
      expect(response).to have_http_status(200)
    end

    it "help" do
      get "/help"
      expect(response).to have_http_status(200)
    end

    it "signup" do
      get "/signup"
      expect(response).to have_http_status(200)
    end

    it "login" do
      get "/login"
      expect(response).to have_http_status(200)
    end
  end

  describe "POST Request" do
    let(:test_error_user_param) do
      {
          params:{
              user: {
                  name: '',
                  email: 'test@invalid.com',
                  password: 'foo',
                  password_confirmation: 'bar'
              }
          }
      }
    end

    let(:test_success_user_param) do
      {
          params:{
              user: {
                  name: 'abcdef',
                  email: 'test@success.com',
                  password: 'rails5',
                  password_confirmation: 'rails5'
              }
          }
      }
    end

    it "response contain error" do
      post users_path, test_error_user_param
      expect(response.status).to eq(200)
      expect(response.body).to include('error')
    end

    it "response success" do
      post users_path, test_success_user_param
      expect(response.status).to eq(302)
    end
  end

  describe "POST Login Request" do
    include SpecTestHelper
    let(:test_error_user_param) do
      {
          params:{
              session: {
                  email: 'test@invalid.com',
                  password: 'foo',
              }
          }
      }
    end

    let(:test_success_user_param) do
      {
          params:{
              session: {
                  email: 'test@success.com',
                  password: 'rails5',
              }
          }
      }
    end

    it "response login contain invalid" do
      post login_path, test_error_user_param
      expect(response.status).to eq(200)
      expect(response.body).to include('Invalid')
      get root_path
      expect(response.body).not_to include('Invalid')
    end

    it "response login success" do
      User.with_writable {User.create(name: 'test', email: 'test@success.com', password: 'rails5', password_confirmation: 'rails5')}
      session = {
          :email => 'test@success.com',
          :password => 'rails5',
      }
      add_session(session)
      post login_path, test_success_user_param
      expect(response.body).not_to include('Invalid')
      expect(response.status).to eq(302)
    end

    describe 'Not Logged in' do
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

      let(:test_login_user_param) do
        {
            params:{
                user: {
                    name: 'test2',
                    email: 'test2@testtest.com',
                    password: 'rails5',
                    password_confirmation: 'rails5'
                }
            }
        }
      end

      before do
        post users_path, test_login_user_param
        post users_path, test_user_param
        @login_user = User.first
        @user2 = User.second
        login @login_user
      end

      it 'not allowed edit' do
        get "/users/#{@user2.id}/edit"
        expect(response).to have_http_status(302)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET Access" do
    fixtures :users

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

    it 'not allowed edit' do
      @user = users(:michael)
      get edit_user_path(@user)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(login_path)
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
                password_confirmation: 'rails5',
                activation_token: User.new_token
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
      expect(response.status).to eq(302)
    end
  end

  describe 'show' do
    fixtures :users
    fixtures :microposts

    it 'profile' do
      @user = users(:michael)
      get user_path(@user)

      expect(response.status).to eq(200)
      expect(response.body.titleize).to include(@user.name)
      expect(response.body).to include('I just ate an orange!')
    end

    it 'micropost pagination' do
      @user = users(:michael)
      get user_path(@user)
      expect(response.body).to include('Next Label')
    end
  end

  describe 'micropost' do
    fixtures :users
    fixtures :microposts

    it 'not login create' do
      post microposts_path ,params: {micropost: {content: 'Lorem ipsum'}}
      expect(response.status).to eq(302)
      expect(response).to redirect_to(login_path)
    end

    it 'not login delete' do
      @micropost = microposts(:orange)
      delete micropost_path(@micropost)
      expect(response.status).to eq(302)
      expect(response).to redirect_to(login_path)
    end
  end

  describe 'relationship' do
    fixtures :users

    it 'show following not login' do
      @user = users(:michael)
      get following_user_path(@user)
      expect(response).to redirect_to(login_url)
    end

    it 'show followwers not login' do
      @user = users(:michael)
      get followers_user_path(@user)
      expect(response).to redirect_to(login_url)
    end
  end
end

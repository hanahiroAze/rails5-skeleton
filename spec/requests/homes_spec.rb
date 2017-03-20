require 'rails_helper'

RSpec.describe "Homes", type: :request do
  # describe "GET Access" do
  #   it "index" do
  #     get "/"
  #     expect(response).to have_http_status(200)
  #   end
  #
  #   it "about" do
  #     get "/about"
  #     expect(response).to have_http_status(200)
  #   end
  #
  #   it "help" do
  #     get "/help"
  #     expect(response).to have_http_status(200)
  #   end
  #
  #   it "signup" do
  #     get "/signup"
  #     expect(response).to have_http_status(200)
  #   end
  #
  #   it "login" do
  #     get "/login"
  #     expect(response).to have_http_status(200)
  #   end
  #
  #   it 'not allowed edit' do
  #     get "/users/0/edit"
  #     expect(response).to have_http_status(302)
  #     expect(flash[:danger]).to include('Please log in')
  #   end
  # end
  #
  # describe "POST Request" do
  #   let(:test_error_user_param) do
  #     {
  #         params:{
  #             user: {
  #                 name: '',
  #                 email: 'test@invalid.com',
  #                 password: 'foo',
  #                 password_confirmation: 'bar'
  #             }
  #         }
  #     }
  #   end
  #
  #   let(:test_success_user_param) do
  #     {
  #         params:{
  #             user: {
  #                 name: 'abcdef',
  #                 email: 'test@success.com',
  #                 password: 'rails5',
  #                 password_confirmation: 'rails5'
  #             }
  #         }
  #     }
  #   end
  #
  #   it "response contain error" do
  #     post users_path, test_error_user_param
  #     expect(response.status).to eq(200)
  #     expect(response.body).to include('error')
  #   end
  #
  #   it "response success" do
  #     post users_path, test_success_user_param
  #     expect(response.status).to eq(302)
  #   end
  # end
  #
  # describe "POST Login Request" do
  #   include SpecTestHelper
  #   let(:test_error_user_param) do
  #     {
  #         params:{
  #             session: {
  #                 email: 'test@invalid.com',
  #                 password: 'foo',
  #             }
  #         }
  #     }
  #   end
  #
  #   let(:test_success_user_param) do
  #     {
  #         params:{
  #             session: {
  #                 email: 'test@success.com',
  #                 password: 'rails5',
  #             }
  #         }
  #     }
  #   end
  #
  #   it "response login contain invalid" do
  #     post login_path, test_error_user_param
  #     expect(response.status).to eq(200)
  #     expect(response.body).to include('Invalid')
  #     get root_path
  #     expect(response.body).not_to include('Invalid')
  #   end
  #
  #   it "response login success" do
  #     User.with_writable {User.create(name: 'test', email: 'test@success.com', password: 'rails5', password_confirmation: 'rails5')}
  #     session = {
  #         :email => 'test@success.com',
  #         :password => 'rails5',
  #     }
  #     add_session(session)
  #     post login_path, test_success_user_param
  #     expect(response.status).to eq(302)
  #   end
  # end

  describe 'pairwise sign in' do
    where(:id, :user_id, :name, :password, :password_confirm, :error_count) do
      [
        [1, 'name @name.jp','name','','nnn', 2],
        [2, '','','nnn','', 5],
        [3, 'name','name@name.jp','nnn','bbbbbb', 3],
        [4, '','name name','nnn','rails5', 4],
        [5, '','','nnn','bbbbbb', 5],
        [6, 'name@name.jp','name@name.jp','nnn','nnn', 1],
        [7, 'name@name.jp','name@name.jp','','rails5', 1],
        [8, 'name','','','rails5', 3],
        [9, 'name @name.jp','','rails5','rails5', 2],
        [10, 'name@name.jp','','rails5','rails5', 1],
        [11, '','name@name.jp','','bbbbbb', 3],
        [12, 'name @name.jp','','','bbbbbb', 3],
        [13, 'name @name.jp','name name','','rails5', 2],
        [14, 'name@name.jp','name name','','', 1],
        [15, 'name@name.jp','name@name.jp','rails5','bbbbbb', 1],
        [16, 'name','name','nnn','bbbbbb', 3],
        [17, '','name','','rails5', 3],
        [18, 'name','name name','','nnn', 2],
        [19, '','name','rails5','bbbbbb', 3],
        [20, 'name@name.jp','','','nnn', 2],
        [21, 'name@name.jp','name','','bbbbbb', 1],
        [22, 'name@name.jp','name','nnn','', 2],
        [23, 'name@name.jp','name@name.jp','nnn','', 2],
        [24, 'name','name name','nnn','nnn', 2],
        [25, 'name @name.jp','name','nnn','bbbbbb', 3],
        [26, '','name@name.jp','','', 3],
        [27, 'name','name','nnn','nnn', 2],
        [28, 'name @name.jp','name','','', 2],
        [29, 'name @name.jp','name@name.jp','','bbbbbb', 2],
        [30, 'name@name.jp','name name','nnn','rails5', 2],
        [31, 'name @name.jp','name@name.jp','rails5','nnn', 2],
        [32, '','name@name.jp','rails5','nnn', 3],
        [33, '','name name','','nnn', 3],
        [34, 'name @name.jp','name name','nnn','rails5', 3],
        [35, 'name','','nnn','rails5', 4],
        [36, 'name@name.jp','name','rails5','rails5', 0],
        [37, '','','rails5','nnn', 4],
        [38, 'name @name.jp','name','rails5','', 2],
        [39, 'name','','','', 3],
        [40, '','name','rails5','', 3],
        [41, 'name','name','rails5','', 2],
        [42, 'name @name.jp','name name','rails5','bbbbbb', 2],
        [43, 'name@name.jp','name name','rails5','nnn', 1],
        [44, 'name@name.jp','name name','','bbbbbb', 1],
        [45, 'name @name.jp','name','nnn','rails5', 3],
        [46, '','name name','nnn','bbbbbb', 4],
        [47, 'name @name.jp','','nnn','nnn', 3],
        [48, 'name','name','rails5','nnn', 2],
        [49, 'name','name name','nnn','', 3],
        [50, 'name','name name','rails5','rails5', 1],
        [51, 'name','','rails5','bbbbbb', 3],
        [52, '','name name','rails5','rails5', 2],
        [53, 'name @name.jp','name@name.jp','nnn','rails5', 3],
        [54, '','name@name.jp','nnn','rails5', 4],
        [55, 'name','name@name.jp','rails5','', 2],
        [56, 'name','name@name.jp','','nnn', 2],
        [57, '','name name','rails5','', 3],
        [58, 'name','name name','','bbbbbb', 2],
        [59, 'name @name.jp','name name','nnn','nnn', 2],
        [60, 'name @name.jp','name@name.jp','nnn','', 3],
        [61, 'name@name.jp','','nnn','bbbbbb', 3],
        [62, '','name','nnn','nnn', 3],
        [63, '','','','rails5', 4],
        [64, 'name@name.jp','name','','nnn', 1],
        [65, 'name@name.jp','','rails5','', 2],
        [66, 'name','name','','rails5', 2],
        [67, 'name @name.jp','name name','','', 2],
        [68, 'name','','nnn','nnn', 3],
        [69, 'name @name.jp','','nnn','', 4]
      ]
    end

    with_them do
      it "#{params[:id]} => #{params[:error_count]} error" do
        testing_params = {
          user: {
            name: name,
            email: user_id,
            password: password,
            password_confirmation: password_confirm
          }
        }
        post users_path, {params: testing_params}
        if error_count == 0
          expect(response.status).to eq(302)
        else
          expect(response.body).to include(error_count.to_s + ' error')
        end
      end
    end
  end
end

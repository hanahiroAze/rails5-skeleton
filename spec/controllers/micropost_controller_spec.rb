require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  describe 'micropost' do
    fixtures :users
    fixtures :microposts

    it 'redirect destroy for wrong post' do
      login users(:michael)
      micropost = microposts(:ants)
      delete :destroy, {params: {id: micropost.id}}
      expect(response).to redirect_to(login_url)
    end
  end
end

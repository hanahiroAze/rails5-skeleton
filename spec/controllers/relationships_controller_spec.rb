require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  describe 'relationships' do
    fixtures :users


    it 'crate requirer logged in' do
      post :create
      expect(response).to redirect_to(login_url)
    end

    it 'delete requirer logged in' do
      user = users(:michael)
      relation = user.follow(users(:archer))
      delete :destroy, {params: {id: relation.id}}
      expect(response).to redirect_to(login_url)
    end
  end
end

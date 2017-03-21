require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    User.with_writable {User.create(name:'aaab', email:'aaa@gmail.xx', password: "foobar", password_confirmation: "foobar")}
    @user = User.first
    @micropost = Micropost.new(content: 'Lorem ipsum', user_id: @user.id)
  end

  describe 'parameters' do
    it 'valid micropost' do
      expect(@micropost.valid?).to eq(true)
    end
    it 'invalid micropost' do
      @micropost.user_id = nil
      expect(@micropost.valid?).to eq(false)
    end
  end
end

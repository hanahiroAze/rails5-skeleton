require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    User.with_writable {User.create(name:'aaab', email:'aaa@gmail.xx', password: "foobar", password_confirmation: "foobar")}
    @user = User.first
    @micropost = @user.microposts.build(content: 'Lorem ipsum')
  end

  describe 'parameters' do
    it 'valid micropost' do
      expect(@micropost.valid?).to eq(true)
    end

    it 'invalid micropost' do
      @micropost.user_id = nil
      expect(@micropost.valid?).to eq(false)
    end

    it 'invalid micropost content blank' do
      @micropost.content = ' '
      expect(@micropost.valid?).to eq(false)
    end

    it 'invalid micropost content too long' do
      @micropost.content = 'a' * 141
      expect(@micropost.valid?).to eq(false)
    end
  end

  describe 'orders' do
    fixtures :microposts
    it 'should be most recent first' do
      expect(microposts(:most_recent)).to eq(Micropost.first)
    end
  end

  describe 'delete' do
    it 'delete posts after destroying user' do
      @user.microposts.create!(content: "Lorem ipsum")
      before = Micropost.count
      @user.destroy
      after = Micropost.count
      expect(before - after).to eq(1)
    end
  end
end

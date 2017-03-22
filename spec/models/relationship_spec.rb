require 'rails_helper'

RSpec.describe Relationship, type: :model do
  fixtures :users

  before do
    @relationship = Relationship.new(follower_id: users(:michael).id,
      followed_id: users(:archer).id)
  end

  describe 'parameters' do
    it 'valid relation' do
      expect(@relationship.valid?).to eq(true)
    end

    it 'invalid follower' do
      @relationship.follower_id = nil
      expect(@relationship.valid?).to eq(false)
    end

    it 'invalid followed' do
      @relationship.followed_id = nil
      expect(@relationship.valid?).to eq(false)
    end

    it 'follow and unfollow' do
      michael = users(:michael)
      archer = users(:archer)

      michael.follow(archer)
      expect(michael.following?(archer)).to eq(true)
      expect(archer.followers.include?(michael)).to eq(true)

      michael.unfollow(archer)
      expect(michael.following?(archer)).not_to eq(true)
    end
  end
end

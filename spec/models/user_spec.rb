require 'rails_helper'
require './spec/models/concerns/authenticable'

RSpec.describe User do
  it_behaves_like "authenticable"
end

RSpec.describe User do
  it 'is valid' do
    user = create(:user, email: 'user@example.org')
    expect(user).to be_valid
  end

  it 'has a unique email' do
    create(:user, email: 'user@example.org')
    another_user = build(:user, email: 'user@example.org')
    expect(another_user).to_not be_valid
  end

  it 'has a unique hashed id' do
    user = create(:user, email: 'user@example.org')
    another_user = build(:user, hashed_id: user.hashed_id)
    expect(another_user).to_not be_valid
  end

  it 'by default is not admin' do
    user = create(:user, email: 'user@example.org')
    expect(user.is_admin?).to be_falsey
  end

  it 'is no valid without first name' do
    user = build(:user, first_name: nil)
    expect(user).to_not be_valid
  end

  it 'is no valid without last name' do
    user = build(:user, last_name: nil)
    expect(user).to_not be_valid
  end

  it 'is no valid without email' do
    user = build(:user, email: nil)
    expect(user).to_not be_valid
  end

  it 'is admin with the right flag' do
    user = create(:user, is_admin: true)
    expect(user.is_admin?).to be_truthy
  end

  it 'no return records' do
    create_list(:user, 5)
    expect(User.search('NON EXISTING DATA')).to match_array([])
  end

  it 'returns only matched records' do
    create(:user, job_title: 'test')
    create(:user, job_title: 'another')
    expect(User.search('test').size).to be(1)
  end

  it 'returns 30 records (page size)' do
    create_list(:user, 15)
    users = User.search('John')
    expect(users.size).to be(10)
    expect(users.total_pages).to be(2)
  end
end

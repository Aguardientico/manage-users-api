RSpec.shared_examples_for 'authenticable' do
  let(:model) { described_class }
  before do
    @user = create(model.to_s.underscore.to_sym, email: 'user@example.org', password: 'dummy')
  end

  it 'has jwt_token' do
    expect(@user.jwt_token).to_not be_nil
  end

  it 'allows to login' do
    expect(model.login(email: 'user@example.org', password: 'dummy')).to eq(@user)
  end

  it 'denies to login without correct password' do
    expect(model.login(email: 'user@example.org', password: 'wrong')).to be_nil
  end

  it 'denies to login to non existing user' do
    expect(model.login(email: 'wrong@example.org', password: 'dummy')).to be_nil
  end

  it 'gets by token' do
    expect(model.get_by_token(@user.jwt_token)).to eq(@user)
  end

  it 'generates exception with wrong token' do
    expect { model.get_by_token('wrong') }.to raise_error(Authenticable::InvalidTokenError)
  end
end

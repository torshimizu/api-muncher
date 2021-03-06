require "test_helper"

describe User do
  describe 'build_from_google' do
    before do
      @user_hash = {
        'uid' => '11111111',
        'provider' => 'google',
        'info' => {
          'email' => 'test@gmail.com',
          'name' => 'test user'
        }
      }
    end

    it 'creates a new user if all required fields are present' do
      result = User.build_from_google(@user_hash)
      result.name.must_equal @user_hash['info']['name']
      result.uid.must_equal @user_hash['uid']
      result.provider.must_equal @user_hash['provider']
      result.email.must_equal @user_hash['info']['email']
    end

    it 'returns the user if the user already exists' do
      user = users(:one)

      result = User.build_from_google(user)
      result.must_equal user
    end

    it 'returns nil if insufficent data is provided' do
      @user_hash['info']['email'] = nil
      result = User.build_from_google(@user_hash)
      result.must_be_nil
    end
  end

  describe 'validations' do
    before do
      @user = User.new(name: 'test', email: 'test@email.com', uid: '1234', provider: 'google')
    end

    it 'requires an email' do
      @user.email = nil
      @user.wont_be :valid?
    end

    it 'can be created with all required data' do
      @user.must_be :valid?
    end

    it 'lets a user favorite a recipe uri only once' do
      favorites(:one).user_id.must_equal users(:one).id

      favorite = Favorite.new(uri: favorites(:one).uri, name: 'Another test name', image: 'image.png', user: users(:one))

      favorite.valid?.must_equal false
      favorite.errors.must_include :uri
    end
  end

  describe 'relations' do
    it 'connects a user and a favorite' do
      Favorite.create!(name: 'Teriyaki Chicken', uri: 'http://www.recipe.com/12345', user: users(:one), image: "https://www.edamam.com/web-img/262/262b4353ca25074178ead2a07cdf7dc1.jpg")

      users(:one).favorites.must_include Favorite.last
    end
  end
end

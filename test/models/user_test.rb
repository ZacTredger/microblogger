require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: 'Example user', email: 'user@example.com',
                     password: 'foobarbaz', password_confirmation: 'foobarbaz')
  end

  test 'example is valid' do
    assert @user.valid?
  end

  test "blank name isn't valid" do
    @user.name = '  '
    assert @user.invalid?
  end

  test "blank email isn't valid" do
    @user.email = '  '
    assert @user.invalid?
  end

  test "really long name isn't valid" do
    @user.name = 'n' * 64
    assert @user.invalid?
  end

  test "really long email isn't valid" do
    @user.email = 'e' * 244 + '@example.com'
    assert @user.invalid?
  end

  test 'valid emails are accepted' do
    valid_addresses = %w[user@example.com 
                         USER@foo.COM
                         A_US-ER@foo.bar.org
                         first.last@foo.jp
                         alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "invalid emails are rejected" do
    invalid_addresses = %w[user@example,com
                           user_at_foo.org
                           user.name@example.
                           foo@bar_baz.com
                           foo@bar+baz.com
                           foo@bar...com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert @user.invalid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'rejects duplicate email' do
    @user.save
    assert @user.dup.invalid?
  end

  test 'rejects duplicate email with different case' do
    @user.save
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    assert duplicate_user.invalid?
  end

  test 'lowers the case of an email' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    assert duplicate_user.save, "Didn't save email: #{duplicate_user}"
    assert_equal @user.email, User.last.email
  end

  test 'requires password' do
    @user.password = ' ' * 9
    assert @user.invalid?
  end

  test 'rejects short password' do
    @user.password_confirmation = @user.password = 'foobar'
    assert @user.invalid?
  end

  test 'rejects if password and confirmation differ' do
    @user.password_confirmation += '+'
    assert @user.invalid?
  end
end

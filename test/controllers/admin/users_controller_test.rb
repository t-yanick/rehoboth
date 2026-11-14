require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  def sign_in(user)
    post session_path, params: { email_address: user.email_address, password: "password" }
    post two_factor_session_path, params: { code: ROTP::TOTP.new(user.otp_secret).now } if user.otp_enabled?
  end

  test "signed-out visitors are sent to the login page" do
    get admin_users_path
    assert_redirected_to new_session_path
  end

  test "warehouse staff cannot manage staff" do
    sign_in users(:warehouse)
    get admin_users_path
    assert_redirected_to admin_root_path
  end

  test "hq admin sees the staff list" do
    sign_in users(:one)
    get admin_users_path
    assert_response :success
  end

  test "hq admin adds a staff member" do
    sign_in users(:one)
    assert_difference("User.count", 1) do
      post admin_users_path, params: { user: {
        name: "Guangzhou Clerk", email_address: "gz@example.com", role: "warehouse_staff",
        locale: "en", active: "1", password: "long-enough-pass", password_confirmation: "long-enough-pass"
      } }
    end
    assert_redirected_to admin_users_path
  end

  test "hq admin cannot demote themselves" do
    sign_in users(:one)
    patch admin_user_path(users(:one)), params: { user: {
      name: "HQ Admin", email_address: users(:one).email_address, role: "agent",
      locale: "en", active: "1", password: "", password_confirmation: ""
    } }
    assert users(:one).reload.hq_admin?
  end

  test "hq admin resets another person's two-step verification" do
    other = users(:warehouse)
    other.update!(otp_secret: ROTP::Base32.random, otp_enabled_at: Time.current)
    sign_in users(:one)
    patch reset_two_factor_admin_user_path(other)
    assert_not other.reload.otp_enabled?
  end
end

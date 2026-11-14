require "test_helper"

class Admin::TwoFactorsControllerTest < ActionDispatch::IntegrationTest
  test "an hq admin without two-step verification must set it up first" do
    post session_path, params: { email_address: users(:hq_no_otp).email_address, password: "password" }
    get admin_root_path
    assert_redirected_to new_admin_two_factor_path
  end

  test "turning on two-step verification with a valid code" do
    user = users(:hq_no_otp)
    post session_path, params: { email_address: user.email_address, password: "password" }
    get new_admin_two_factor_path
    assert_response :success

    post admin_two_factor_path, params: { code: ROTP::TOTP.new(user.reload.otp_secret).now }
    assert user.reload.otp_enabled?
    assert_redirected_to admin_root_path
  end

  test "a wrong setup code does not turn it on" do
    user = users(:hq_no_otp)
    post session_path, params: { email_address: user.email_address, password: "password" }
    get new_admin_two_factor_path
    post admin_two_factor_path, params: { code: "000000" }
    assert_not user.reload.otp_enabled?
  end
end

require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "shows the sign-in page" do
    get new_session_path
    assert_response :success
  end

  test "staff without two-step verification go straight to the admin" do
    post session_path, params: { email_address: users(:warehouse).email_address, password: "password" }
    assert_redirected_to admin_root_url
  end

  test "staff with two-step verification are asked for a code" do
    post session_path, params: { email_address: users(:one).email_address, password: "password" }
    assert_redirected_to new_two_factor_session_path
  end

  test "a correct code completes sign-in" do
    user = users(:one)
    post session_path, params: { email_address: user.email_address, password: "password" }
    post two_factor_session_path, params: { code: ROTP::TOTP.new(user.otp_secret).now }
    assert_redirected_to admin_root_url
  end

  test "a wrong code is refused" do
    post session_path, params: { email_address: users(:one).email_address, password: "password" }
    post two_factor_session_path, params: { code: "000000" }
    assert_redirected_to new_two_factor_session_path
  end

  test "the code page needs the password step first" do
    get new_two_factor_session_path
    assert_redirected_to new_session_path
  end

  test "wrong password is refused" do
    post session_path, params: { email_address: users(:warehouse).email_address, password: "wrong" }
    assert_redirected_to new_session_path
  end

  test "disabled staff cannot sign in" do
    post session_path, params: { email_address: users(:inactive).email_address, password: "password" }
    assert_redirected_to new_session_path
  end

  test "sign out" do
    post session_path, params: { email_address: users(:warehouse).email_address, password: "password" }
    delete session_path
    assert_redirected_to new_session_path
  end
end

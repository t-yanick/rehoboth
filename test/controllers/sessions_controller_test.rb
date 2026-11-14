require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "shows the sign-in page" do
    get new_session_path
    assert_response :success
  end

  test "valid credentials go to the admin" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_redirected_to admin_root_url
  end

  test "wrong password is refused" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }
    assert_redirected_to new_session_path
  end

  test "disabled staff cannot sign in" do
    post session_path, params: { email_address: users(:inactive).email_address, password: "password" }
    assert_redirected_to new_session_path
  end

  test "sign out" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    delete session_path
    assert_redirected_to new_session_path
  end
end

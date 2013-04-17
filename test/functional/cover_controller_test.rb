require 'test_helper'

class CoverControllerTest < ActionController::TestCase
  test "should get cover" do
    get :cover
    assert_response :success
  end

end

require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get signin" do
    get :signin
    assert_response :success
  end

  test "should get register" do
    get :register
    assert_response :success
  end

  test "should get movies" do
    get :movies
    assert_response :success
  end

  test "should get theatres" do
    get :theatres
    assert_response :success
  end

  test "should get preferences" do
    get :preferences
    assert_response :success
  end

  test "should get settings" do
    get :settings
    assert_response :success
  end

  test "should get buddies" do
    get :buddies
    assert_response :success
  end

  test "should get home" do
    get :home
    assert_response :success
  end

end

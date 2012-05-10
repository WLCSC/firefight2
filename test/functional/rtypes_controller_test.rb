require 'test_helper'

class RtypesControllerTest < ActionController::TestCase
  setup do
    @rtype = rtypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rtypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rtype" do
    assert_difference('Rtype.count') do
      post :create, rtype: @rtype.attributes
    end

    assert_redirected_to rtype_path(assigns(:rtype))
  end

  test "should show rtype" do
    get :show, id: @rtype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rtype
    assert_response :success
  end

  test "should update rtype" do
    put :update, id: @rtype, rtype: @rtype.attributes
    assert_redirected_to rtype_path(assigns(:rtype))
  end

  test "should destroy rtype" do
    assert_difference('Rtype.count', -1) do
      delete :destroy, id: @rtype
    end

    assert_redirected_to rtypes_path
  end
end

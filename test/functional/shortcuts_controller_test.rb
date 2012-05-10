require 'test_helper'

class ShortcutsControllerTest < ActionController::TestCase
  setup do
    @shortcut = shortcuts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shortcuts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shortcut" do
    assert_difference('Shortcut.count') do
      post :create, shortcut: @shortcut.attributes
    end

    assert_redirected_to shortcut_path(assigns(:shortcut))
  end

  test "should show shortcut" do
    get :show, id: @shortcut
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shortcut
    assert_response :success
  end

  test "should update shortcut" do
    put :update, id: @shortcut, shortcut: @shortcut.attributes
    assert_redirected_to shortcut_path(assigns(:shortcut))
  end

  test "should destroy shortcut" do
    assert_difference('Shortcut.count', -1) do
      delete :destroy, id: @shortcut
    end

    assert_redirected_to shortcuts_path
  end
end

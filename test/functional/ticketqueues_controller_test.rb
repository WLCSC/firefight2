require 'test_helper'

class TicketqueuesControllerTest < ActionController::TestCase
  setup do
    @ticketqueue = ticketqueues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ticketqueues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ticketqueue" do
    assert_difference('Ticketqueue.count') do
      post :create, ticketqueue: @ticketqueue.attributes
    end

    assert_redirected_to ticketqueue_path(assigns(:ticketqueue))
  end

  test "should show ticketqueue" do
    get :show, id: @ticketqueue
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ticketqueue
    assert_response :success
  end

  test "should update ticketqueue" do
    put :update, id: @ticketqueue, ticketqueue: @ticketqueue.attributes
    assert_redirected_to ticketqueue_path(assigns(:ticketqueue))
  end

  test "should destroy ticketqueue" do
    assert_difference('Ticketqueue.count', -1) do
      delete :destroy, id: @ticketqueue
    end

    assert_redirected_to ticketqueues_path
  end
end

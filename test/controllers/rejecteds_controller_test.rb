require 'test_helper'

class RejectedsControllerTest < ActionController::TestCase
  setup do
    @rejected = rejecteds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rejecteds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rejected" do
    assert_difference('Rejected.count') do
      post :create, rejected: { name: @rejected.name }
    end

    assert_redirected_to rejected_path(assigns(:rejected))
  end

  test "should show rejected" do
    get :show, id: @rejected
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rejected
    assert_response :success
  end

  test "should update rejected" do
    patch :update, id: @rejected, rejected: { name: @rejected.name }
    assert_redirected_to rejected_path(assigns(:rejected))
  end

  test "should destroy rejected" do
    assert_difference('Rejected.count', -1) do
      delete :destroy, id: @rejected
    end

    assert_redirected_to rejecteds_path
  end
end

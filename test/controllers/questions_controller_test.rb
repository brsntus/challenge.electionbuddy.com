require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:one)
    @election = elections(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get election_questions_url(election_id: @election)
    assert_response :success
  end

  test "should get new" do
    get new_election_question_url(election_id: @election)
    assert_response :success
  end

  test "should create question" do
    assert_difference('Question.count') do
      post election_questions_url(election_id: @election), params: { question: { answer_ids: @question.answer_ids, name: @question.name } }
    end

    assert_redirected_to question_url(Question.last)
  end

  test "should show question" do
    get question_url(@question)
    assert_response :success
  end

  test "should get edit" do
    get edit_question_url(@question)
    assert_response :success
  end

  test "should update question" do
    patch question_url(@question), params: { question: { answer_ids: @question.answer_ids, name: @question.name } }
    assert_redirected_to question_url(@question)
  end

  test "should destroy question" do
    assert_difference('Question.count', -1) do
      delete question_url(@question)
    end

    assert_redirected_to election_questions_url(@election)
  end
end

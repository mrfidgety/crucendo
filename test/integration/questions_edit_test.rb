require 'test_helper'

class QuestionsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:richard)
    @question = questions(:q1)
  end

  test "unsuccessful edit" do
    log_in_as @user
    get edit_admin_question_path(@question)
    assert_template 'questions/edit'
    patch admin_question_path(@question), question: { content:  "" }
    assert_template 'questions/edit'
  end
end

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  
  def setup
    @question = Question.new(content: "How are you?", question_category_id: 1)
  end
  
  test "should be valid" do
    assert @question.valid?
  end
  
  test "content should be present" do
    @question.content = "    "
    assert_not @question.valid?
  end
  
  test "content should not be too long" do
    @question.content = "a" * 181
    assert_not @question.valid?
  end
end

class Interaction < ActiveRecord::Base
  
  belongs_to  :user
  has_many    :answers, dependent:  :destroy
  has_many    :goals
  has_many    :improvements
  
  before_create :assign_question_answers
  
  validates :user_id, presence: true
  
  # find first linked answer that is incomplete
  def find_next_answer
    answers.where(:content => nil).first
  end
  
  # set interaction as completed
  def complete
    update_attribute(:completed, true)
  end
  
  def get_question_topics
    goals.topics
  end
  
  private
  
    # assign questions to interaction
    def assign_question_answers
      # @questions = Question.active.order("RANDOM()").limit(3)
      # @questions.each do |question|
      #   answers.build(question_id: question.id, user_id: user.id)
      # end
      
      @topics_answered = user.topics
                          .eager_load(questions: {answers: :interaction } )
                          .where(interactions: {user_id: user.id})
                          .order("answers.created_at DESC")
                          
      topics_answered_ids = @topics_answered.pluck(:id)
      
      @topics_remainder = user.topics.where.not(id: topics_answered_ids).order("RANDOM()")
      
      @topics_all = @topics_answered + @topics_remainder
      
      @topics_hash = @topics_all.map{ |t| [t, (@topics_all.index(t)+1) ** 2] }.to_h
      @topics_hash = @topics_hash.to_a.reverse.to_h
      
      @topics_shuffled = shuffle(@topics_hash)
      
      @topics_shuffled.each do |topic|
        if question = topic.find_next_question(user)
          answers.build(question_id: question.id, user_id: user.id)
        end
        break if answers.size >= 3
      end
    end

  def shuffle some_hash
    result = []
    
    numbers = some_hash.keys
    weights = some_hash.values
    total_weight = weights.reduce(:+)
    
    # choose numbers one by one
    until numbers.empty?
      # weight from total range of weights
      selection = rand() * total_weight
    
      # find which element this corresponds with
      i = 0
      while selection > 0
         selection -= weights[i]
         i += 1
      end
      i -= 1
    
      # add number to result and remove corresponding weight
      result << numbers[i]
      numbers.delete_at i
      total_weight -= weights.delete_at(i)
    end
    
    result
  end
end

class Admin::TopicsController < AdminController
  before_action :find_topic, only: [:show, :edit, :update, :destroy]
  before_action :insert_breadcrumbs
  
  def index
    @topics = Topic.admin.paginate(page: params[:page])
  end
  
  def show
  end

  def new
    @topic = Topic.new
  end
  
  def edit
  end
  
  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      set_flash :successful_create, type: :success, object: @topic
      redirect_to admin_topics_path
    else
      render 'new'
    end
  end
  
  def update
    if @topic.update_attributes(topic_params)
      set_flash :generic_successful_update, type: :success
      redirect_to admin_topic_path(@topic)
    else
      render 'edit'
    end
  end
  
  def destroy
    if !@topic.questions.empty?
      set_flash :questions_assigned_error, type: :danger, object: @topic
      redirect_to admin_topic_path(@topic)
    else
      Topic.find(params[:id]).destroy
      set_flash :successful_destroy, type: :success, object: @topic
      redirect_to admin_topics_path
    end
  end
  
  def activate_questions
    @topic = Topic.find(params[:id])
    @topic.questions.update_all(active: true)
    redirect_to admin_topic_path(@topic)
  end
  
  private
  
    def find_topic
      @topic = Topic.find(params[:id])
    end
  
    def topic_params
      params.require(:topic).permit(:name, :active, :author, 
        :default_subscription, :picture)
    end
  
    def insert_breadcrumbs
      add_breadcrumb "admin", :admin_path
      case action_name
        when 'index'
          add_breadcrumb "topics"
        when 'show'
          add_breadcrumb "topics", :admin_topics_path
          add_breadcrumb @topic.name
        when 'edit', 'update'
          add_breadcrumb "topics", :admin_topics_path
          add_breadcrumb @topic.name, admin_topic_path(@topic)
          add_breadcrumb "edit"
        when 'new'
          add_breadcrumb "topics", :admin_topics_path
          add_breadcrumb "new"
      end
    end
end
class PostsController < ApplicationController
  before_action :find_post, only: [:show]
  before_action :validate_search, only: :index
  
  # Display blog home page
  def index
    @posts = Post.active(true).most_recent.filter(
                        params.slice(:min_date, :max_date))
                        .paginate(:per_page => 5, :page => params[:page])
    @tracks = Topic.all
  end
  
  # Display single blog post
  def show
  end
  
  private
  
    def find_post
      @post = Post.find(params[:id])
      
      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the post_path, and we should do
      # a 301 redirect that uses the current friendly id.
      if request.path != post_path(@post)
        return redirect_to @post, :status => :moved_permanently
      end
    end
    
    def validate_search
      params[:min_date] = Time.zone.parse(params[:min_date]) if params.has_key?(:min_date)
      params[:max_date] = Time.zone.parse(params[:max_date]) if params.has_key?(:max_date)
    end
  
end
class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:show, :edit, :update]
  before_action :correct_user,    only: [:show, :edit, :update]
  
  def show
    redirect_to root_url
  end
  
  def new
    @user = User.new
  end
  
  def create
    # check if user exists
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      if @user.activated?
        # create login digest and send email
        @user.send_login_email
        set_flash :send_login, type: :success, object: @user
        redirect_to root_url
      else
        if @user.activation_link_expired?
          # resend activation
          @user.resend_activation_email
          set_flash :resend_activation, type: :success, object: @user
        else
          # prompt for activation to be resent
          set_flash :resend_activation_prompt, type: :success, object: @user
        end
        redirect_to root_url
      end
    else
      # attempt to create new user
      @user = User.new(user_params)
      if @user.save
        # send activation email
        @user.send_activation_email
        set_flash :send_activation, type: :success, object: @user
        redirect_to root_url
      else
        render 'new'
      end
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(user_params)
      set_flash :successful_update, type: :success, object: @user
      redirect_to profile_path
    else
      render 'edit'
    end
  end
  
  def resend
    @user = User.find_by(email: params[:email].downcase)
    if @user && !@user.activated?
      @user.resend_activation_email
      set_flash :resend_activation_confirm, type: :success, object: @user
      redirect_to root_url
    end
  end
  
  private

    def user_params
      params.require(:user).permit( :name, 
                                    :email, 
                                    :year_of_birth, 
                                    :gender, 
                                    :country_code)
    end
    
    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        set_flash :link_error, type: :warning
        redirect_to begin_path
      end
    end
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(current_user.id)
      redirect_to(root_url) unless @user == current_user
    end
end

class Public::SubjectsController < ApplicationController
  before_action :is_matching_subjects_id, only: [:show]
  
  def index
    @subjects = Subject.where(status: true).page(params[:page]).per(5)
    @tag_list=Tag.page(params[:page])
    @all_favorites = Answer.find(Favorite.group(:answer_id).limit(5).order('count(answer_id) desc').pluck(:answer_id))
  end
  
  def new
    @subject = Subject.new
  end
  
  def check
    @subject = Subject.new(subject_params)
    @subject.user_id = current_user.id
    #subjectのタグ名ごとの配列を#で区切っていいる
    tag_list = params[:subject][:name].split('#')
   if @subject.save
     #save_tagはモデルに記載
     @subject.save_tag(tag_list)
     render :check
   else
     redirect_to new_subject_path
   end
  end
  
  def create
    @user = current_user.id
    @subject = Subject.last
    if @subject.update(subject_params)
       redirect_to user_path(@user)
    end
  end
  
  def show
    @subject = Subject.find(params[:id])
    @answer = Answer.new
    @subject_tags = @subject.tags
    @all_favorites = Answer.find(Favorite.group(:answer_id).order('count(answer_id) desc').limit(10).pluck(:answer_id))
    @time_limit = Date.parse(@subject.time_limit) 
  end
  
  def edit
    @subject = Subject.find(params[:id])
    @tag_list = @subject.tags.pluck(:name).join('#')
    unless @subject.user_id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end
  
  def update
    @subject = Subject.find(params[:id])
    tag_list = params[:subject][:name].split('#')
    if @subject.update(subject_params)
       @subject.save_tag(tag_list)
      redirect_to user_path(current_user.id)
    else
      render :edit
    end
  end
  
  def destroy
     subject = Subject.find(params[:id])
     subject.destroy
     redirect_to user_path(current_user.id)
  end
  
  private
  
    def subject_params
      params.require(:subject).permit(:subject_image, :time_limit, :title, :theme, :user_id, :status)
    end
  
    def is_matching_subjects_id
      subject = Subject.find_by(id: params[:id])
     if subject.nil? || subject.status == false
      redirect_to homes_top_path
     end
    
    end 

end

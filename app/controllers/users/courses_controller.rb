class Users::CoursesController < Users::BaseController
  PER_PAGE = 3

  before_action :find_course, only: [:edit, :update, :show, :destroy, :move]

  def index
    @courses = current_user.authored_courses.recent.page(params[:page]).per(params[:per_page] || PER_PAGE)
  end

  def new
    @course = current_user.authored_courses.build
  end

  def create
    @course = current_user.authored_courses.build(courses_params)

    if @course.save
      redirect_to users_courses_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @course.update(courses_params)
      redirect_to users_courses_path
    else
      render :edit
    end
  end

  def show
    @course_lessons = find_course.lessons.ordered_by_position_asc
  end

  def destroy
    @course.destroy

    redirect_to users_courses_path
  end

  def move
    @course_lesson = find_course.lessons.find(params[:id])
    @course_lesson.move_to! params[:position]
  end

  private

  def find_course
    @course = current_user.authored_courses.find(params[:id])
  end

  def courses_params
    params.require(:course).permit(:title, :picture)
  end
end

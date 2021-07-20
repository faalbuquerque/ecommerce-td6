class Admin::CategoriesController < Admin::AdminController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @categories = Category.all
    @category = Category.new
  end

  def create
    @category = Category.new(category_params) 
    @category.parent = set_father_category
    return redirect_to admin_categories_path if @category.save!

    @categories = Category.all
    render :new
  end
 

  private

  def set_father_category
    return nil if params[:category][:ancestry].blank?

    Category.find(params[:category][:ancestry])
  end

  def category_params
    params.require(:category).permit(:name, :status)
  end

end

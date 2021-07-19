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

    # father_category = Category.find_by(id: params[:category_id])
    # @category.category = father_category if father_category and @category.valid?

    return redirect_to admin_categories_path if @category.save!

    @categories = Category.all
    render :new
  end

  private

  def category_params
    params.require(:category).permit(:name, :status, :subcategory)
  end

end

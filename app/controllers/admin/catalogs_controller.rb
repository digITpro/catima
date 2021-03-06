class Admin::CatalogsController < Admin::BaseController
  rescue_from Exception, with: :exception_rescue
  layout "admin/form"

  def new
    build_catalog
    authorize(@catalog)
  end

  def create
    build_catalog
    authorize(@catalog)
    if @catalog.update(catalog_params)
      redirect_to(admin_dashboard_path, :notice => created_message)
    else
      render("new")
    end
  end

  def edit
    find_catalog
    authorize(@catalog)
    @admins = @catalog.users_with_role("admin")
  end

  def update
    find_catalog
    authorize(@catalog)
    if @catalog.update(catalog_params)
      redirect_to(admin_dashboard_path, :notice => updated_message)
    else
      render("edit")
    end
  end

  def destroy
    find_catalog
    authorize(@catalog)
    destroy_catalog
    redirect_to(admin_dashboard_path, :notice => destroyed_message)
  end

  private

  def build_catalog
    @catalog = Catalog.new
  end

  def find_catalog
    @catalog = Catalog.where(:slug => params[:slug]).first!
  end

  def destroy_catalog
    @catalog.update(custom_root_page_id: nil)
    @catalog.destroy
  end

  def catalog_params
    params.require(:catalog).permit(
      :name,
      :slug,
      :primary_language,
      :requires_review,
      :advertize,
      :visible,
      :restricted,
      :custom_root_page_id,
      :deactivated_at,
      :other_languages => []
    )
  end

  def created_message
    "The “#{@catalog.name}” catalog has been created."
  end

  def destroyed_message
    "The “#{@catalog.name}” catalog has been deleted."
  end

  def updated_message
    message = "The “#{@catalog.name}” catalog has been "
    if catalog_params.key?(:deactivated_at)
      message << (@catalog.active? ? "reactivated." : "deactivated.")
    else
      message << "updated."
    end
    message
  end

  def exception_rescue(exception)
    redirect_to(admin_dashboard_path, :alert => exception.to_s)
  end
end

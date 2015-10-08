class Admin::CatalogsController < Admin::BaseController
  layout "admin/form"

  def new
    build_catalog
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

  def update
    find_catalog
    authorize(@catalog)
    if @catalog.update(catalog_params)
      redirect_to(admin_dashboard_path, :notice => updated_message)
    else
      render("edit")
    end
  end

  private

  def build_catalog
    @catalog = Catalog.new
  end

  def find_catalog
    @catalog = Catalog.find(params[:id])
  end

  def catalog_params
    params.require(:catalog).permit(
      :name,
      :slug,
      :primary_language,
      :requires_review,
      :deactivated_at,
      :other_languages => []
    )
  end

  def created_message
    "Catalog “#{@catalog.name}” has been created."
  end

  def updated_message
    if catalog_params.key?(:deactivated_at)
      @catalog.active? ? "Catalog reactivated." : "Catalog deactivated."
    else
      "Catalog updated."
    end
  end
end

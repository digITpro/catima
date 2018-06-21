class ExportPolicy
  attr_reader :user, :export
  delegate :catalog, :to => :export

  def initialize(user, export)
    @user = user
    @export = export
  end

  def create?
    return false unless user.authenticated?
    return true if user.system_admin?
    user.catalog_role_at_least?(catalog, "admin")
  end

  def download?
    return false unless export.valid?
    return false unless export.ready?
    create?
  end
end

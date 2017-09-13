namespace :catalog do
  desc "Drop a catalog"
  task :drop => [:environment] do
    (slug = ENV['catalog']) || raise("ERROR. No catalog specified. \n\rUSAGE: rake catalog:dump catalog=<slug>")
    (c = Catalog.find_by(slug: slug)) || raise("ERROR. No catalog '#{slug}' found.")
    c.destroy
  end
end

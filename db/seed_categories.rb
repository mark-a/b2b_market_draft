require 'yaml'

module SeedCategories
  include Search

  def create_categories
    categories = [
        {id: 1, title: "products", parent_id: nil},
        {id: 2, title: "services", parent_id: nil},
        {id: 3, title: "flange", parent_id: 1},
        {id: 4, title: "fitting", parent_id: 1},
        {id: 5, title: "pipe", parent_id: 1},
        {id: 6, title: "semifinished_semisteel", parent_id: 1},
        {id: 7, title: "forge_ring_rolled", parent_id: 1},
        {id: 8, title: "sheet", parent_id: 1},
        {id: 9, title: "welding", parent_id: 2},
        {id: 10, title: "machining", parent_id: 2},
        {id: 11, title: "testing", parent_id: 2},
        {id: 12, title: "production_output", parent_id: 2},
    ]

    categories.map { |params| Category.new(params).save }

    category_de_translations = {
        products: "Produkte",
        services: "Dienstleistungen",
        flange: "Flansch",
        fitting: "Fitting",
        pipe: "Rohr",
        semifinished_semisteel: "Halbzeug & Halbstahl",
        forge_ring_rolled: "Schmiede- & Ringwalzprodukte",
        sheet: "Blech",
        welding: "Schweißen",
        machining: "Mechanische Bearbeitung",
        testing: "Erproben",
        production_output: "Produktionsleistung",
    }

    file = File.expand_path("../../config/locales/de.yml", __FILE__)
    locales = YAML::load_file(file)
    locales['de'] = {} unless locales['de']
    locales['de']['categories'] = {} unless locales['de']['categories']
    category_de_translations.each do |key, value|
      locales['de']['categories'][key] = value
    end
    File.open(file, 'w') { |f| f.write locales.to_yaml }
  end
end

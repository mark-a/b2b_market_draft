require_relative "seed_categories"
include SeedCategories
create_categories


include Search
[
    {id: 1, title: "Werkstoff"},
    {id: 2, title: "Produkt"},
    {id: 3, title: "Abmessungen"},
    {id: 4, title: "Anforderungen"},
    {id: 5, title: "Dienstleistung"},
    {id: 6, title: "Produktionsverfahren"},
].map { |params| CriteriumGroup.new(params).save }

[
    {category_id: 3, criterium_group_id: 1, order: 1},
    {category_id: 3, criterium_group_id: 5, order: 2},
    {category_id: 3, criterium_group_id: 3, order: 3},
    {category_id: 3, criterium_group_id: 4, order: 4},
    {category_id: 4, criterium_group_id: 1, order: 1},
    {category_id: 4, criterium_group_id: 2, order: 2},
    {category_id: 4, criterium_group_id: 3, order: 3},
    {category_id: 4, criterium_group_id: 4, order: 4},
    {category_id: 5, criterium_group_id: 1, order: 1},
    {category_id: 5, criterium_group_id: 2, order: 2},
    {category_id: 5, criterium_group_id: 3, order: 3},
    {category_id: 5, criterium_group_id: 4, order: 4},
    {category_id: 6, criterium_group_id: 1, order: 1},
    {category_id: 6, criterium_group_id: 2, order: 2},
    {category_id: 6, criterium_group_id: 3, order: 3},
    {category_id: 6, criterium_group_id: 4, order: 4},
    {category_id: 7, criterium_group_id: 1, order: 1},
    {category_id: 7, criterium_group_id: 2, order: 2},
    {category_id: 7, criterium_group_id: 3, order: 3},
    {category_id: 7, criterium_group_id: 4, order: 4},
    {category_id: 8, criterium_group_id: 1, order: 1},
    {category_id: 8, criterium_group_id: 2, order: 2},
    {category_id: 8, criterium_group_id: 3, order: 3},
    {category_id: 8, criterium_group_id: 4, order: 4},
    {category_id: 9, criterium_group_id: 1, order: 1},
    {category_id: 9, criterium_group_id: 2, order: 2},
    {category_id: 9, criterium_group_id: 3, order: 3},
    {category_id: 9, criterium_group_id: 4, order: 4},
    {category_id: 10, criterium_group_id: 1, order: 1},
    {category_id: 10, criterium_group_id: 5, order: 2},
    {category_id: 10, criterium_group_id: 3, order: 3},
    {category_id: 10, criterium_group_id: 4, order: 4},
    {category_id: 11, criterium_group_id: 1, order: 1},
    {category_id: 11, criterium_group_id: 5, order: 2},
    {category_id: 11, criterium_group_id: 4, order: 3},
    {category_id: 12, criterium_group_id: 5, order: 1},
    {category_id: 12, criterium_group_id: 4, order: 2},
].map { |params| CategoryMembership.new(params).save }


Category.where.not(parent_id: nil).each do |category|

  file = File.expand_path("../criteria/#{category.title}.csv", __FILE__)
  puts "Reading #{file} ..."

  criteria = {}
  values = []

  CSV.foreach(file, headers: true).with_index do |row, index|
    if index % 100 == 0
      puts "Line #{index+1}"
    end

    row.to_h.each do | key, value |
      criterium = criteria[key] || criteria[key] = Search::Criterium.create(name: key, category_id: category.id, valuetype: 'set'); criteria[key]
      if value
        unless value.include?("…") || value.include?("(ohne Nachkommastelle)")
          values.push({criterium_id: criterium.id, title: value,created_at: Time.now, updated_at: Time.now})
        else
          criterium.valuetype = "range"

          if value.include?("(ohne Nachkommastelle)")
            criterium.divisor = 1
            min_val, max_val = value.split(/[-…]/).map{|x| x.tr('^0-9', '').to_i}
            criterium.min = min_val
            criterium.max = max_val
          else
            min_float, max_float = value.split(/[-…]/).map{|x| x.tr('.','').tr(',', '.').to_f}
            criterium.divisor = (1.0 / min_float).to_i
            criterium.min =  (min_float * (1.0 / min_float)).to_i
            criterium.max =  (max_float * (1.0 / min_float)).to_i
          end
          criterium.save
        end
      end
    end
  end

  Search::CriteriumValue.insert_all(values)
end


#Search::Criterium.find_or_create_by(name: key)
#crit_value = Search::CriteriumValue.create_with(criterium_id: criterium.id).find_or_create_by(title: value)


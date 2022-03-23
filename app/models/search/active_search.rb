module Search
  class ActiveSearch
    def initialize(raw_params)
      @selection = []
      raw_params&.each do |key, values|
        values.each do |value|
          @selection.push SelectedCriterium.new(key.to_i, value.to_i) unless !value || value.empty?
        end
      end
    end

    def pretty_print
      @selection.map do |selection|
        crit = Criterium.find(selection.id)
        if crit.valuetype == "range"
          [crit.name, selection.value, selection.id, selection.value]
        else
          value = CriteriumValue.find(selection.value)
          [crit.name, value.title, selection.id, selection.value]
        end
      end
    end

    def selected?(id)
      @selection.map(&:id)&.include? id.to_s
    end

    def selection
      @selection
    end

  end
end

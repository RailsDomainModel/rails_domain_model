class RailsDomainModel::Event < RailsEventStore::Event

  def method_missing(m, *args, &block)  
    return data.with_indifferent_access[m] if data.keys.map(&:to_sym).include?(m)

    super(m, args, block)
  end

end

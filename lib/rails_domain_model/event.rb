class RailsDomainModel::Event < RailsEventStore::Event

  # To make it easier to access the event data.
  def method_missing(m, *args, &block)  
    return data.with_indifferent_access[m] if data.keys.map(&:to_sym).include?(m)

    super(m, args, block)
  end

end

class RailsDomainModel::CommandHandler
  def initialize(command)
    @command = command
  end

  def handle!
    aggregate = aggregate_class.new._load(stream_name)
    aggregate.send(aggregate_method, @command)
    aggregate._store
  end

  private

  def stream_name
    "#{aggregate_class}$#{aggregate_id}"
  end

  def aggregate_class
    @command.class.aggregate_class
  end

  def aggregate_id
    @command.send(@command.class.aggregate_id_attribute)
  end

  def aggregate_method
    @command.class.aggregate_method
  end
end


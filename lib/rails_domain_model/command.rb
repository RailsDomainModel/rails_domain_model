class RailsDomainModel::Command
  class ValidationError < RuntimeError
    attr_accessor :errors
    def initialize(errors)
      @errors = errors
    end
  end

  class << self
    attr_accessor :aggregate_class, :aggregate_id, :aggregate_method
  end

  def self.with_aggregate(klass, call:)
    @aggregate_class  = klass
    @aggregate_method = call

    validates :aggregate_id, presence: true
  end

  def execute!
    validate!

    RailsDomainModel::CommandHandler.new(self).handle!
  end

  def aggregate_id
    raise NotImplementedError.new('You should implement the aggregate_id')

  private

  def validate!
    fail ValidationError.new(errors), errors.messages.inspect unless valid?
  end

end

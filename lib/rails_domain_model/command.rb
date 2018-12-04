class RailsDomainModel::Command
  class ValidationError < RuntimeError
    attr_accessor :errors
    def initialize(errors)
      @errors = errors
    end
  end

  class << self
    attr_accessor :aggregate_class, :aggregate_id_attribute, :aggregate_method
  end

  def self.with_aggregate(klass, id_attribute, method)
    @aggregate_class        = klass
    @aggregate_id_attribute = id_attribute
    @aggregate_method       = method

    validates @aggregate_id_attribute, presence: true
  end

  def execute!
    validate!

    RailsDomainModel::CommandHandler.new(self).handle!
  end

  private

  def validate!
    fail ValidationError.new(errors), errors.messages.inspect unless valid?
  end

end

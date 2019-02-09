module RailsDomainModel::EventSerializer
  module_function

  def serialize(message)
    hash = message.to_h
    hash[:message_type] = message.class.to_s
    hash.to_json
  end

  def self.deserialize(json)
    hash = JSON.parse(json, { symbolize_names: true })

    klass = hash.delete(:message_type)
    hash.delete(:type)

    klass = ActiveSupport::Inflector.constantize(klass)
    klass.new hash
  end
end

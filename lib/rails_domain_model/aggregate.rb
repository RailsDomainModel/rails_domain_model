require 'aggregate_root/default_apply_strategy'

class RailsDomainModel::Aggregate

  def self.on(*event_klasses, &block)
    event_klasses.each do |event_klass|
      name = event_klass.name || raise(ArgumentError, "Anonymous class is missing name")
      handler_name = "on_#{name}"
      define_method(handler_name, &block)
      @on_methods ||= {}
      @on_methods[event_klass]=handler_name
      private(handler_name)
    end
  end

  def self.on_methods
    ancestors.
      select{|k| k.instance_variables.include?(:@on_methods)}.
      map{|k| k.instance_variable_get(:@on_methods) }.
      inject({}, &:merge)
  end

  def _apply(*events)
    events.each do |event|
      _apply_strategy.(self, event)
      _unpublished << event
    end
  end

  def _load(stream_name, event_store: _default_event_store)
    @_loaded_from_stream_name = stream_name
    _events_enumerator(event_store, stream_name).with_index do |event, index|
      _apply(event)
      @_version = index
    end
    @_unpublished_events = nil
    self
  end

  def _store(stream_name = _loaded_from_stream_name, event_store: _default_event_store)
    event_store.publish(_unpublished, stream_name: stream_name, expected_version: version)
    @_version += _unpublished_events.size
    @_unpublished_events = nil
  end

  def _unpublished_events
    _unpublished.each
  end

  private

  def _unpublished
    @_unpublished_events ||= []
  end

  def version
    @_version ||= -1
  end

  def _apply_strategy
    AggregateRoot::DefaultApplyStrategy.new(on_methods: self.class.on_methods)
  end

  def _default_event_store
    Rails.configuration.event_store
  end

  def _events_enumerator(event_store, stream_name)
    event_store.read.in_batches.stream(stream_name).each
  end

  attr_reader :_loaded_from_stream_name
end


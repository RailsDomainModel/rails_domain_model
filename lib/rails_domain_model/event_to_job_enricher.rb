Rails.application.eager_load!

jobs = ApplicationJob.descendants
events = DomainEvent.descendants.map do |e|
  [e.to_s.gsub('Domain::', '').gsub('Events::', ''), e]
end.to_h
puts events

jobs.each do |job|
  split = job.to_s.split('::')
  split.shift
  without_context = split.join('::').gsub(/Job$/, '')

  if event = events[without_context]
    puts "prepending to #{job}"
    job.class_eval do
      prepend RailsEventStore::AsyncHandler
    end
    EVENT_STORE.subscribe(job, to: [event])
  else
    puts "NOT prepending to #{job}"
  end
end


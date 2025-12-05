class TestJob < ApplicationJob
  queue_as :default

  def perform(name)
    puts "Hello #{name}, job executed!"
  end
end

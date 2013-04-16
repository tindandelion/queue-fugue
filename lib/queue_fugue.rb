require 'queue_fugue/messaging'
require 'queue_fugue/beat_counter'
require 'queue_fugue/configuration'
require 'queue_fugue/application'
require 'queue_fugue/jfugue_player'
require 'queue_fugue/version'

module QueueFugue
  def self.create_application(player_class, config_file = nil, &block)
    config = Configuration.new
    config.apply_external(config_file) if config_file
    config.apply_block(&block) if block
    
    player = player_class.new(config.instruments)
    counters = config.counters + [config.default_counter]
    Application.new(player, counters)
  end
end

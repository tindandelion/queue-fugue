require 'queue_fugue/beat_counter'
require 'queue_fugue/configuration'

describe 'Configuration' do
  let(:config) { QueueFugue::Configuration.new }
  let(:config_file) { stub(:file) }
  
  it 'has no default instrument to play'
  it 'has no background beat'
  
  it 'configures the background beat' do
    config.background_beat '..**..!!..', '*' => 'BANJO', '!' => 'PIANO'
    
    config.background_beat_string.should eq('..**..!!..')
    
    instruments = config.instruments
    instruments['*'].should eq('BANJO')
    instruments['!'].should eq('PIANO')
  end
  
  it 'creates beat counters with corresponding instruments' do
    config.play 'BANJO', when: ->(msg){ msg.size > 100 }
    config.play 'PIANO', when: ->(msg){ msg.size > 1000 }
    
    config.should have_counter(0, 'BANJO')
    config.should have_counter(1, 'PIANO')
  end
  
  it 'configures the default beat counter as the last counter' do
    config.play 'MARACAS', default: true
    config.play 'BANJO', when: ->(msg){ msg.size > 100 }
    
    last_index = 1
    config.should have_counter(last_index, 'MARACAS')
  end
  
  it 'treats instrument as default if no criterion is specified' do
    config.play 'MARACAS'
    config.play 'BANJO', when: ->(msg){ msg.size > 100 }

    last_index = 1
    config.should have_counter(last_index, 'MARACAS')
  end
  
  it 'applies an external configuration file to itself' do
    config_string = "play 'MARACAS', default: true"
    
    config_file.should_receive(:exist?).and_return(true)
    config_file.should_receive(:read).and_return(config_string)
    
    config.apply_external(config_file)
    config.should have_counter(0, 'MARACAS')
  end
  
  it 'stays intact if external file does not exist' do
    lambda {
      config_file.should_receive(:exist?).and_return(false)
      config.apply_external(config_file)
    }.should_not raise_error
  end
end

RSpec::Matchers.define :have_counter do |index, instrument|
  match do |config|
    counter = config.counters[index]
    config.instruments[counter.marker] == instrument
  end
  
  failure_message_for_should do |actual_config|
    "expected config to have a beat counter playing #{instrument} at index: #{index}, " +
      "but found counters for: #{collect_instruments(actual_config).join(', ')}"
  end
  
  def collect_instruments(config)
    config.counters.collect {|c| config.instruments[c.marker] }
  end
end

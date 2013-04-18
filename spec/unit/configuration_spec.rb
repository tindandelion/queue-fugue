require 'queue_fugue/configuration'

describe 'Configuration' do
  let(:config) { QueueFugue::Configuration.new }
  let(:config_file) { stub(:file) }
  
  it 'has no default instrument to play'
  it 'treats instrument as default if no criterion is specified'
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
    
    instruments = config.instruments
    instruments['A'].should eq('BANJO')
    instruments['B'].should eq('PIANO')
    
    counters = config.counters
    counters.size.should eq(2)
    counters[0].marker.should eq('A')
    counters[1].marker.should eq('B')
  end
  
  it 'configures the default beat counter as the last counter' do
    config.play 'MARACAS', default: true
    config.play 'BANJO', when: ->(msg){ msg.size > 100 }
    
    instruments = config.instruments
    instruments['A'].should eq('MARACAS')
    
    default_counter = config.counters.last
    default_counter.marker.should eq('A')
  end
  
  it 'applies an external configuration file to itself' do
    config_string = "play 'MARACAS', default: true"
    
    config_file.should_receive(:exist?).and_return(true)
    config_file.should_receive(:read).and_return(config_string)
    
    config.apply_external(config_file)
    
    config.instruments['A'].should eq('MARACAS')
  end
  
  it 'stays intact if external file does not exist' do
    lambda {
      config_file.should_receive(:exist?).and_return(false)
      config.apply_external(config_file)
    }.should_not raise_error
  end
end

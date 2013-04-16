require 'queue_fugue/configuration'

describe 'Configuration' do
  let(:config) { QueueFugue::Configuration.new }
  let(:config_file) { stub(:file) }

  it 'has no default instrument to play'
  
  it 'holds default configuration after creation' do
    config.instruments['*'].should eq('BASS_DRUM')
    config.instruments['+'].should eq('CRASH_CYMBAL_1')
  end
  
  it 'overrides the default instrument if specified' do
    config.instruments do
      map 'O', to: 'MARACAS'
    end
    
    instruments = config.instruments
    instruments['O'].should eq('MARACAS')
    instruments['*'].should eq('BASS_DRUM')
    instruments['+'].should eq('CRASH_CYMBAL_1')
  end
  
  it 'configures the default instrument' do
    config.play_default 'MARACAS'
    
    instruments = config.instruments
    instruments['A'].should eq('MARACAS')
    
    config.default_counter.marker.should eq('A')
  end
  
  
  it 'configures beat counters' do
    config.rhythms do
      play '+', when: ->(msg){ msg.size > 1000 }
    end
    
    config.counters.should_not be_empty
    config.counters.first.marker.should eq('+')
  end
  
  it 'applies an external configuration file to itself' do
    config_string = "instruments do; map 'O', to: 'MARACAS'; end"
    
    config_file.should_receive(:exist?).and_return(true)
    config_file.should_receive(:read).and_return(config_string)
    
    config.apply_external(config_file)
    
    config.instruments['O'].should eq('MARACAS')
  end
  
  it 'stays intact if external file does not exist' do
    lambda {
      config_file.should_receive(:exist?).and_return(false)
      config.apply_external(config_file)
    }.should_not raise_error
  end
end

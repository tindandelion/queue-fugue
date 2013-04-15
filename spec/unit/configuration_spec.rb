require 'queue_fugue/configuration'

describe 'Configuration' do
  let(:config) { QueueFugue::Configuration.new }
  let(:config_file) { stub(:file) }
  
  it 'holds default configuration after creation' do
    config.default_instrument.should eq('O')
    
    config.instruments['*'].should eq('BASS_DRUM')
    config.instruments['O'].should eq('ACOUSTIC_SNARE')
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
  
  it 'can override the default instrument' do
    config.rhythms do
      default_instrument 'x'
    end
    
    config.default_instrument.should eq('x')
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

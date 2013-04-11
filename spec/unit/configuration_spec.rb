require 'queue_fugue/configuration'

describe 'Configuration' do
  let(:config) { QueueFugue::Configuration.new(:player_class) }
  let(:config_file) { stub(:file) }
  
  it 'creates a default mapping if file not exists' do
    config_file.should_receive(:exist?).and_return(false)
    config.apply_external(config_file)
    
    instruments = config.instruments
    instruments['*'].should eq('BASS_DRUM')
    instruments['O'].should eq('ACOUSTIC_SNARE')
    instruments['+'].should eq('CRASH_CYMBAL_1')
  end
  
  it 'overrides the defaults with the mappings from the file' do
    config_string = "instruments do; map 'O', to: 'MARACAS'; end"
    
    config_file.should_receive(:exist?).and_return(true)
    config_file.should_receive(:read).and_return(config_string)
    
    config.apply_external(config_file)
    
    instruments = config.instruments
    instruments['O'].should eq('MARACAS')
    instruments['*'].should eq('BASS_DRUM')
    instruments['+'].should eq('CRASH_CYMBAL_1')
  end
end

require 'queue_fugue/jfugue_player'
require 'queue_fugue/instruments'

describe 'Instruments' do
  
  let(:instruments) { QueueFugue::Instruments.new }
  
  it 'adds default substitutions' do
    rhythm = org.jfugue.Rhythm.new
    
    instruments.apply_to(rhythm)
    
    rhythm.should substitute('.' => 'Rs')
    rhythm.should substitute('!' => '[CRYSTAL]s')
  end
  
  it 'adds custom instrument substitution' do
    rhythm = org.jfugue.Rhythm.new
    
    instruments.add_mapping 'O', 'BASS_DRUM'
    instruments.apply_to(rhythm)
    
    rhythm.should substitute('O' => '[BASS_DRUM]s')
  end
end

RSpec::Matchers.define :substitute do |expected_sub|
  match do |player|
    placeholder, sub = expected_sub.first
    player.get_substitution(placeholder[0].ord) == sub
  end
end


require 'rhythm_synthesizer'

describe "Rhythm Synthesizer" do
  
  let(:synth) { RhythmSynthesizer.new }
  
  let(:background_beat) { ['....*.....**...!'] }
  let(:message_size) { 5 }
  
  it 'produces only background rhythm track if no messages received' do
    rhythm = synth.produce_rhythm
    rhythm.should eq(background_beat)
  end
  
  it 'resets to blank state when the rhythm is produced' do
    synth.message_received(message_size)
    synth.produce_rhythm
    
    new_rhythm = synth.produce_rhythm
    new_rhythm.should eq(background_beat)
  end
  
  it 'varies track intensity depending on a number of messages received' do
    2.times { synth.message_received(message_size) }
    rhythm = synth.produce_rhythm
    rhythm.should eq(['....O.......O...'] + background_beat)
    
    8.times { synth.message_received(message_size) }
    rhythm = synth.produce_rhythm
    rhythm.should eq(['.O.O.O.O.O.O.O.O'] + background_beat)
  end
  
  it 'protects track from being overflown' do
    20.times { synth.message_received(message_size) }
    rhythm = synth.produce_rhythm
    rhythm.should eq(['OOOOOOOOOOOOOOOO'] + background_beat)
  end
  
  it 'produces an additional track for very long messages' do
    synth.message_received(message_size)
    synth.message_received(message_size + RhythmSynthesizer::LONG_MESSAGE_THRESHOLD)
    
    rhythm = synth.produce_rhythm
    rhythm.should eq(['........+.......', '........O.......'] + background_beat)
  end
end

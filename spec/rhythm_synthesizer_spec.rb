require 'rhythm_synthesizer'

describe "Rhythm Synthesizer" do

  let(:synth) { RhythmSynthesizer.new }
  
  it 'has 0 messages by default' do
    synth.messages_received.should eq(0)
  end
  
  it 'maintains message count' do
    synth.message_received
    synth.messages_received.should eq(1)
  end
  
  it 'produces background rhythm if no messages received' do
    rhythm = synth.produce_rhythm
    rhythm.should eq(['....*.....**...!'])
  end
  
  it 'resets message count when the rhythm is produced' do
    synth.message_received
    rhythm = synth.produce_rhythm
    synth.messages_received.should eq(0)
  end
  
  it 'produces a beat string for 1 message' do
    synth.message_received
    rhythm = synth.produce_rhythm
    rhythm.should eq(['........O.......', '....*.....**...!'])
  end

  it 'produces a beat string for 2 messages' do
    2.times { synth.message_received }
    rhythm = synth.produce_rhythm
    rhythm.should eq(['....O.......O...', '....*.....**...!'])
  end
  
  
  it 'produces a beat string for 8 messages' do
    8.times { synth.message_received }
    rhythm = synth.produce_rhythm
    rhythm.should eq(['.O.O.O.O.O.O.O.O', '....*.....**...!'])
  end
  
  it 'produces max beat string when overflows' do
    20.times { synth.message_received }
    rhythm = synth.produce_rhythm
    rhythm.should eq(['OOOOOOOOOOOOOOOO', '....*.....**...!'])
  end
end

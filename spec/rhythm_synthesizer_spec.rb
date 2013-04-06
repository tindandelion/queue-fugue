require 'rhythm_synthesizer'

describe "Rhythm Synthesizer" do

  let(:synth) { RhythmSynthesizer.new }
  
  it 'has 0 messages by default' do
    synth.messages_received.should eq(0)
  end
  
  it 'maintains message count' do
    synth.message_received
    synth.messages_received.should eq(1)
    
    synth.reset
    synth.messages_received.should eq(0)
  end
end

require 'queue_fugue/rhythm_synthesizer'

class TestMessage
  attr_accessor :text

  def initialize(size)
    @text = '!' * size
  end
end

describe "Rhythm Synthesizer" do
  
  let(:background_beat) { ['....*.....**...!'] }
  let(:message_size) { 5 }
  
  
  context 'with default beat counters' do
    let(:synth) { QueueFugue::RhythmSynthesizer.new('O') }
    
    it 'produces only background rhythm track if no messages received' do
      rhythm = synth.produce_rhythm
      rhythm.should eq(background_beat)
    end
    
    it 'mixes backround beat and the rhythm produced' do
      8.times { synth.message_received(TestMessage.new(message_size)) }
      rhythm = synth.produce_rhythm
      rhythm.should eq(['.O.O.O.O.O.O.O.O'] + background_beat)
    end
    
    it 'resets to blank state when the rhythm is produced' do
      synth.message_received(TestMessage.new(message_size))
      synth.produce_rhythm
      
      new_rhythm = synth.produce_rhythm
      new_rhythm.should eq(background_beat)
    end
  end
  
  context 'with custom beat counters' do
    it 'produces an additional beat track per counter' do
      custom_counter = QueueFugue::BeatCounter.new('+', lambda { |msg| msg.text.size > message_size })
      synth = QueueFugue::RhythmSynthesizer.new('O', [custom_counter])
      
      synth.message_received(TestMessage.new(message_size))
      synth.message_received(TestMessage.new(message_size + 10))
      
      rhythm = synth.produce_rhythm
      rhythm.should eq(['........+.......', '........O.......'] + background_beat)
    end
  end
end

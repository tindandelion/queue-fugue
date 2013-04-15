require 'queue_fugue/rhythm_synthesizer'

class TestMessage
  attr_accessor :text

  def initialize(size)
    @text = '!' * size
  end
end

describe "Rhythm Synthesizer" do
  let(:default_counter) { QueueFugue::BeatCounter.new('O') }
  let(:background_beat) { ['....*.....**...!'] }
  let(:message_size) { 5 }
  
  
  context 'with a single beat counter' do
    let(:synth) { QueueFugue::RhythmSynthesizer.new([default_counter]) }
    
    it 'produces only background rhythm track if no messages received' do
      rhythm = synth.produce_rhythm
      rhythm.should eq(background_beat)
    end
    
    it 'mixes backround beat and the rhythm produced' do
      8.times { synth.message_received(TestMessage.new(message_size)) }
      rhythm = synth.produce_rhythm
      rhythm.should eq(['.O.O.O.O.O.O.O.O'] + background_beat)
    end
  end
  
  context 'with multiple beat counters' do
    it 'splits a rhythm into several tracks according to beat counters' do
      long_message_counter = QueueFugue::BeatCounter.new('+', lambda { |msg| msg.text.size > message_size })
      synth = QueueFugue::RhythmSynthesizer.new([long_message_counter, default_counter])
      
      
      synth.message_received(TestMessage.new(message_size))
      synth.message_received(TestMessage.new(message_size + 10))
      
      rhythm = synth.produce_rhythm
      rhythm.should eq(['........+.......', '........O.......'] + background_beat)
    end
  end
end

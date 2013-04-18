require 'queue_fugue/beat_counter'

describe 'BeatCounter' do
  let(:bc) { QueueFugue::BeatCounter.new('x') }
  
  it 'has initial state' do
    bc = QueueFugue::BeatCounter.new('x')
    
    bc.marker.should eq('x')
    bc.produce_rhythm.should eq([])
  end
  
  it 'produces a beat string for 1' do
    bc = QueueFugue::BeatCounter.new('x')
    
    bc.process(:message)
    bc.produce_rhythm.should eq(['........x.......'])
  end
  
  it 'produces a beat string with appropriate amount of beats' do
    bc = QueueFugue::BeatCounter.new('x')
    
    8.times { bc.process(:message) }
    bc.produce_rhythm.should eq(['.x.x.x.x.x.x.x.x'])
  end
  
  it 'protects counter from being overflown' do
    bc = QueueFugue::BeatCounter.new('x')
    
    20.times { bc.process(:message) }
    bc.produce_rhythm.should eq(['xxxxxxxxxxxxxxxx'])
  end
  
  it 'resets to zero when produced rhythm' do
    bc = QueueFugue::BeatCounter.new('x')
    
    bc.process(:message)
    bc.produce_rhythm.should_not be_empty
    bc.produce_rhythm.should be_empty
  end
  
  it 'only increments if message satisfies a criterion' do
    bc = QueueFugue::BeatCounter.new('x')
    bc.filter_by { |msg| msg == :special_message }
    
    result = bc.process(:message)
    bc.produce_rhythm.should be_empty
    result.should be_false
    
    
    result = bc.process(:special_message)
    bc.produce_rhythm.should_not be_empty
    result.should be_true
  end
  
  it 'applies the scale factor to counted beats' do
    bc.scale_by 0.5
    
    2.times { bc.process(:message) }
    
    bc.produce_rhythm.should eq(['........x.......'])
  end
  
end

require 'queue_fugue/beat_counter'

describe 'BeatCounter' do
  it 'has initial state' do
    bc = QueueFugue::BeatCounter.new('x')
    
    bc.marker.should eq('x')
    bc.produce_rhythm.should eq([])
  end
  
  it 'produces a beat string for 1' do
    bc = QueueFugue::BeatCounter.new('x')
    
    bc.inc
    bc.produce_rhythm.should eq(['........x.......'])
  end
  
  it 'produces a beat string with appropriate amount of beats' do
    bc = QueueFugue::BeatCounter.new('x')
    
    8.times { bc.inc }
    bc.produce_rhythm.should eq(['.x.x.x.x.x.x.x.x'])
  end
  
  it 'resets to zero when produced rhythm' do
    bc = QueueFugue::BeatCounter.new('x')
    
    bc.inc
    bc.produce_rhythm.should_not be_empty
    bc.produce_rhythm.should be_empty
  end
end

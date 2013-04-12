require 'queue_fugue/beat_counter'

describe 'BeatCounter' do
  it 'creates' do
    bc = QueueFugue::BeatCounter.new('x')
    bc.should be_zero
    bc.marker.should eq('x')
  end
end

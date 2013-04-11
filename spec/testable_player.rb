require 'queue_fugue/jfugue_player'

class TestablePlayer < QueueFugue::JFuguePlayer
  attr_reader :music_string
  
  def play(pattern)
    @music_string = pattern.music_string
  end
  
  protected
  
  def with_player(&block)
    block.call(self)
  end
end

RSpec::Matchers.define :played_beats do |instrument, count|
  match do |player|
    beats_played = player.music_string.scan(instrument)
    beats_played.size == count
  end
  
  failure_message_for_should do |player|
    "expected player to play [#{instrument}] #{count} time(s),\n" +
      "but it actually played #{filter_instruments(player.music_string)}"
  end
  
  def filter_instruments(music_string)
    music_string.scan(/\[\w*\]/).join(', ')
  end
end

RSpec::Matchers.define :played_music_string do |expected_string|
  match do |player|
    player.music_string == expected_string
  end
  
  failure_message_for_should do |player|
    "expected player to play the string [#{expected_string}],\n" +
      "but it actually played [#{player.music_string}]"
  end
end

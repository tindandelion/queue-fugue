module QueueFugue
  class BeatCounter
    PATTERNS = ['........_.......',
                '...._......._...',
                '..._...._...._..',
                '.._..._..._..._.',
                '.._.._.._.._.._.',
                '._.._._._._.._..',
                '._._._._.._._._.',
                '._._._._._._._._',
                '._._._.___._._._',
                '._.___._._.___._',
                '._.___.___.___._',
                '__.___.___.___._',
                '__._______.___._',
                '__.___________._',
                '__._____________',
                '________________']
    
    attr_reader :marker
    attr_reader :count
    
    def initialize(marker, criterion = lambda { |msg| true })
      @marker = marker
      @count = 0
      @criterion = criterion
    end

    def satisfy?(message)
      @criterion.call(message)
    end
    
    def inc
      @count += 1
    end
    
    def produce_rhythm
      result = calculate_strings
      @count = 0
      result
    end
    
    private
    
    def calculate_strings
      return [] if @count.zero?
      
      beat_position = [@count - 1, PATTERNS.length - 1].min
      pattern = PATTERNS[beat_position]
      return [pattern.gsub('_', @marker)]
    end
  end
end

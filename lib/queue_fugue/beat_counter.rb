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
    
    def initialize(marker)
      @marker = marker
      @count = 0
      @criterion = lambda { |msg| true }
      @scale_factor = 1
    end
    
    def filter_by(&block)
      @criterion = block
    end
    
    def scale_by(factor)
      @scale_factor = factor
    end
    
    def process(message)
      satisfies = @criterion.call(message)
      @count += 1 if satisfies
      satisfies
    end
    
    def produce_rhythm
      result = calculate_strings
      @count = 0
      result
    end
    
    private
    
    def calculate_strings
      return [] if @count.zero?
      
      beat_position = [scaled_count - 1, PATTERNS.length - 1].min
      pattern = PATTERNS[beat_position]
      return [pattern.gsub('_', @marker)]
    end
    
    def scaled_count
      @count * @scale_factor
    end
  end
end

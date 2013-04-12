module QueueFugue
  class BeatCounter
    attr_reader :marker
    attr_reader :count
    
    def initialize(marker)
      @marker = marker
      @count = 0
    end
    
    def inc
      @count += 1
    end
    
    def zero?
      @count.zero?
    end
  end
end

class Instruments
  def initialize
    @substitutions = Hash.new
  end
  
  def add_mapping(placeholder, instrument)
    @substitutions[placeholder] = instrument
  end
  
  def apply_to(rhythm)
    apply_default(rhythm)
    apply_custom(rhythm)
  end
  
  private
  
  def apply_default(rhythm)
    rhythm.add_substitution to_char('!'), '[CRYSTAL]s'
    rhythm.add_substitution to_char('.'), 'Rs'
  end
  
  def apply_custom(rhythm)
    @substitutions.each_pair do |char, instrument|
      rhythm.add_substitution to_char(char), "[#{instrument}]s"
    end
  end
  
  def to_char(str)
    str[0].ord
  end
end

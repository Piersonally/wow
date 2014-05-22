class CssClassList < Array

  def initialize(*classes)
    replace normalize_array_or_string(classes)
  end

  def <<(classes)
    replace self + normalize_array_or_string(classes)
    uniq!
  end

  def to_s
    join ' '
  end

  private

  def normalize_array_or_string(classes)
    if classes.is_a?(String)
      classes.split ' '
    elsif classes.is_a?(Array)
      classes.flatten.join(' ').split(' ')
    elsif classes.nil?
      []
    else
      raise 'CssClassList takes an Array or String'
    end
  end
end

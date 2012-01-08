class String
  # Prefixes the string with other +str+
  #
  #  "Foo".prefix('(') # => "(Foo"
  def prefix(str)
    str + self
  end

  # Suffixes the string with other +str+
  # "Foo".suffix(')') # => "Foo)"
  def suffix(str)
    self + str
  end

  # Wraps string with given +prefix+ and +suffix+
  #
  #  # For multiple character prefixes and suffixes
  #  "Foo".wrap('((', '))') # => "((Foo))"
  #
  #  # For single character prefixes and suffixes, the following shorthand is provided
  #  "Foo".wrap('()') # => "(Foo)"
  def wrap(*args)
    px, sx = args                 if args.length == 2
    px, sx = args.first.split(//) if args.length == 1 && args.first.length == 2

    raise ArgumentError unless px && sx

    self.prefix(px).suffix(sx)
  end
end

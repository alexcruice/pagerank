# encapsulates relevant meta information about a web page
class Page
  def initialize(*args)
    @parent = args.flatten.select { |arg| arg.is_a? Page }.first
    @keywords = args.flatten.select { |arg| arg.is_a? String }.map { |keyword| keyword.downcase }.uniq
    # pity String#downcase returns nil on an already lowercase String
    # would remove double iteration
  end

  def keywords
    (@keywords + (@parent.nil? ? [] : @parent.keywords)).uniq
  end
end

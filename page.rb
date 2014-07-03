# Encapsulates basic meta information about a web page, namely keywords.
# It's possible to nest a page, simply throw a reference to the immediate
# parent page in the arguments.
class Page
  def initialize(*args)
    args.flatten!
    @parent = args.select { |arg| arg.is_a? Page }.first
    args.select! { |arg| arg.is_a? String }
    @keywords = args.map { |keyword| keyword.downcase }.uniq
    # pity String#downcase returns nil on an already lowercase String
    # would remove double iteration
  end

  def keywords
    (@keywords + (@parent.nil? ? [] : @parent.keywords)).uniq
  end
end

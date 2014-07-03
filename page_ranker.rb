require 'celluloid/autostart'
require_relative 'simple_rank'
require_relative 'page'

# provides page ranking services by maintaining a list of Pages and
# responding to queries using the included ranking function
class PageRanker
  include Celluloid # taadaa Actor!
  include SimpleRank # mixin ranking function of choice

  DEFAULT_MAX_KEYWORDS = 8

  def initialize(n = DEFAULT_MAX_KEYWORDS)
    @max_keywords = n.respond_to?(:to_int) ? n.to_int : DEFAULT_MAX_KEYWORDS
    @pages = []
    @num_queries = 0
  end

  def add_page(*args)
    @pages << Page.new(args) # pages sanitise their arguments
  end

  def service_query(*query_keywords)
    # ranking functions expect cleaned keyword list
    query_keywords.flatten!
    query_keywords.select! { |arg| arg.is_a? String }
    query_keywords.map! { |keyword| keyword.downcase }.uniq!

    results = {}

    @pages.map.with_index do |page, index|
      page_rank = rank(page.keywords, query_keywords, @max_keywords)
      results["P#{index + 1}"] = page_rank if page_rank > 0
    end

    results = results.sort_by { |_, rank| -rank } # descending order

    results.reduce("Q#{@num_queries += 1}:") do |output, result|
      output << " #{result.first}" # append page number
    end
  end
end

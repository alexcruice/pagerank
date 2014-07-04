require 'celluloid/autostart'
require_relative 'simple_rank'
require_relative 'page'

Celluloid.logger = nil

# provides page ranking services by maintaining a list of Pages and
# responding to queries using the included ranking function
class PageRanker
  include Celluloid # taadaa Actor!
  include SimpleRank # mixin ranking function of choice

  DEFAULT_MAX_KEYWORDS = 8
  MAX_RESULTS = 5

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

    # transforms Hash to sorted, nested Arrays
    results = results.sort do |a, b|
      sort_by_rank = -a.last <=> -b.last # descending rank
      sort_by_rank == 0 ? a.first <=> b.first : sort_by_rank # ascending page
    end

    output = "Q#{@num_queries += 1}:"
    results.first(MAX_RESULTS).map { |result| output << " #{result.first}" }
    $stdout.puts output # print returns nil
    output # return for testing
  end

  def spawn_spider(input_source)
    InputSpider.new(:ranker, input_source) if input_source.is_a? IO
  end

  # inner class that funnels tasks into a PageRanker
  # crawls over given input source for pages and queries
  class InputSpider
    include Celluloid # unsure if this is really necessary here

    def initialize(ranker, input)
      until input.eof?
        tokens = input.gets.split

        case tokens.shift
        when 'P'
          begin
            # presently no method of recognising a nested page
            # would go here if there was
            Actor[ranker].async.add_page(tokens)
          end
        when 'Q'
          begin
            Actor[ranker].async.service_query(tokens)
          end
        end
      end unless Actor[ranker].nil?
    end
  end
end

PageRanker.supervise_as :ranker # for dealing with DeadActorError

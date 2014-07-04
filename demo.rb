require_relative 'page_ranker'

# simple PageRanker demo
ranker = PageRanker.new
ranker.spawn_spider($stdin)

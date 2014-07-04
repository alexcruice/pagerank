# Given a list of page keywords and a list of query keywords,
# SimpleRank provides basic relationship strength quantification
# between page and query keywords.
# Ranking functions should adhere to the following guidelines:
# - expect pre-sanitised keyword lists
# - return an integer >= 0 indicating the strength of the relationship
# - the higher the return value, the greater the strength
module SimpleRank
  private

  def rank(page_keywords, query_keywords, n)
    query_keywords.first(n).each_with_index.reduce(0) do |product_sum, (q_keyword, index)|
      p_index = page_keywords.first(n).index(q_keyword)
      product_sum + (p_index.nil? ? 0 : n - p_index) * (n - index)
    end
  end
end

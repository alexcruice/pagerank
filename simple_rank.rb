module SimpleRank
  private

  def rank(page_keywords, query_keywords, n)
    query_keywords.map! { |keyword| keyword.downcase }.uniq!
    query_keywords[0...n].each_with_index.reduce(0) do |product_sum, (q_keyword, index)|
      p_index = page_keywords.index(q_keyword)
      product_sum + (p_index.nil? ? 0 : n - p_index) * (n - index)
    end
  end
end

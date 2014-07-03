require_relative '../simple_rank'

# dummy class for module testing
class TestClass
  include SimpleRank
end

describe SimpleRank do
  let(:ranker) { TestClass.new }
  let(:page1) { %w(ford car review) }
  let(:page2) { %w(toyota car) }
  let(:page3) { %w(car ford) }
  let(:query1) { %w(fOrd Car) }
  let(:query2) { %w(FORD revieW) }
  let(:max_keywords) { 8 }

  describe '#rank' do
    it 'works correctly' do
      # ugly __send__ to test private method #rank
      expect(ranker.__send__(:rank, page1, query1, max_keywords)).to eq(113)
      expect(ranker.__send__(:rank, page2, query1, max_keywords)).to eq(49)
      expect(ranker.__send__(:rank, page3, query1, max_keywords)).to eq(112)
      expect(ranker.__send__(:rank, page1, query2, max_keywords)).to eq(106)
      expect(ranker.__send__(:rank, page2, query2, max_keywords)).to eq(0)
      expect(ranker.__send__(:rank, page3, query2, max_keywords)).to eq(56)
    end
  end
end

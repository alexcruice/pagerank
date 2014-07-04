require_relative '../page_ranker'

describe PageRanker do
  let(:ranker) { PageRanker.new }
  let(:page1) { Page.new(%w(Ford CAR rEview)) }
  let(:page2) { Page.new(%w(Toyota CAr)) }
  let(:page3) { Page.new(%w(Car fOrD CAR ford)) }

  describe '#add_page' do
    it 'adds pages' do
      # only real comparison is via keywords unless I make Page comparable
      expect(ranker.add_page(%w(Ford CAR rEview)).last.keywords).to eq(page1.keywords)
      expect(ranker.add_page(%w(Toyota CAr)).last.keywords).to eq(page2.keywords)
      expect(ranker.add_page(%w(Car fOrD CAR ford)).last.keywords).to eq(page3.keywords)
    end

    it 'services queries' do
      # lazy loading requires I add the pages again
      ranker.add_page(%w(Ford CAR rEview))
      ranker.add_page(%w(Toyota CAr))
      ranker.add_page(%w(Car fOrD CAR ford))
      expect(ranker.service_query(%w(Ford Car))).to eq('Q1: P1 P3 P2')
      expect(ranker.service_query(%w(Ford Review))).to eq('Q2: P1 P3')
    end

    it 'produces correct sample output' do
      ranker.add_page(%w(Ford Car Review))
      ranker.add_page(%w(Review Car))
      ranker.add_page(%w(Review Ford))
      ranker.add_page(%w(Toyota Car))
      ranker.add_page(%w(Honda Car))
      ranker.add_page(%w(Car))
      expect(ranker.service_query(%w(Ford))).to eq('Q1: P1 P3')
      expect(ranker.service_query(%w(Car))).to eq('Q2: P6 P1 P2 P4 P5')
      expect(ranker.service_query(%w(Review))).to eq('Q3: P2 P3 P1')
      expect(ranker.service_query(%w(Ford Review))).to eq('Q4: P3 P1 P2')
      expect(ranker.service_query(%w(Ford Car))).to eq('Q5: P1 P3 P6 P2 P4')
      expect(ranker.service_query(%w(cooking French))).to eq('Q6:')
    end
  end
end

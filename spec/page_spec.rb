require_relative '../page'

describe Page do
  let(:page1) { Page.new(%w(Ford CAR rEview)) }
  let(:page2) { Page.new(%w(Toyota CAr)) }
  let(:page3) { Page.new(%w(Car fOrD CAR ford)) }
  let(:nested_page) { Page.new(page2, %w(all NEW keywords)) }
  let(:double_nested_page) { Page.new(nested_page, %w(car some more)) }

  describe '#keywords' do
    it 'filters duplicates and transforms keywords to lowercase' do
      expect(page1.keywords).to eq(%w(ford car review))
      expect(page2.keywords).to eq(%w(toyota car))
      expect(page3.keywords).to eq(%w(car ford))
    end

    it 'sees parents keywords' do
      expect(nested_page.keywords).to eq(%w(all new keywords toyota car))
      expect(double_nested_page.keywords).to eq(%w(car some more all new keywords toyota))
    end
  end
end

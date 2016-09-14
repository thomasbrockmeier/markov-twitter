require 'rails_helper'

describe MarkovChainer do
  describe '.initialize' do
    context "when initialized" do
      it "without arguments" do
        mc = MarkovChainer.new
        expect(mc).to be_a MarkovChainer
        expect(mc.input_text).to eql('')
        expect(mc.order).to eql(2)
        expect(mc.n_paragraphs).to eql(3)
        expect(mc.n_sentences).to eql(5)
      end

      it "with arguments" do
        mc = MarkovChainer.new(
        input_text: "text",
        order: 5,
        n_paragraphs: 8,
        n_sentences: 10
        )

        expect(mc.input_text).to eql('text')
        expect(mc.order).to eql(5)
        expect(mc.n_paragraphs).to eql(8)
        expect(mc.n_sentences).to eql(10)
      end
    end
  end

  describe '.process_twitter_account' do
    mc = MarkovChainer.new(
    input_text: "kanyewest",
    order: 2,
    n_paragraphs: 2,
    n_sentences: 2
    )

    processed_text = mc.process_twitter_account

    it 'returns a string' do
      expect(processed_text.class).to eql(String)
    end

    it 'consists of n_paragraphs' do
      expect(processed_text.scan(/<\s*p[^>]*>/i).size).to eql(mc.n_paragraphs)
    end

    it 'does not contain URLs' do
      expect(processed_text.scan(/(http(|s):\/\/\S*|www.\S*)/i).size).to eql(0)
    end

    it 'does not contain hashtags' do
      expect(processed_text.scan(/(#\S*)/).size).to eql(0)
    end

    it 'does not contain Twitter handles' do
      expect(processed_text.scan(/(@\S*)/).size).to eql(0)
    end
  end
end

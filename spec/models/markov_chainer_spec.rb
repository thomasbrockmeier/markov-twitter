require 'rails_helper'

describe MarkovChainer do
  describe '.initialize' do
    context "creates instance" do
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
end

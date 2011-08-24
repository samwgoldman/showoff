require 'spec_helper'

describe MarkdownProcessor do
  let(:content) { File.read(File.join(File.dirname(__FILE__), '..', 'example', 'one', 'slidesA.md')) }
  let(:processor) { MarkdownProcessor.new(content) }
  subject { processor }

  describe '#content' do
    its(:content) { should == content }
  end

  context 'when content does not include slides' do
    let(:content) { '# test' }

    it { should_not have_explicit_slides }
    its(:processed_content) { should match("SLIDE") }

    describe '#slidify' do
      it { should have(1).slides }
      it 'should include test in the first slide' do
        subject.slides.first.should include("test")
      end
    end
  end

  context 'when content includes one slide' do
    let(:content) { "!SLIDE one two three\n# first heading" }

    it { should have_explicit_slides }

    it 'should include SLIDE once' do
      processor.processed_content.scan(/SLIDE/).should have(1).items
    end

    it 'should only include first heading as content in the first slide' do
      subject.slides.first.should include("first heading")
      subject.slides.first.should_not include("test")
    end
  end

  context 'when content includes two slides' do
    let(:content) { "!SLIDE\n#first slide\n!SLIDE\n#second slide" }

    it { should have_explicit_slides }
    it { should have(2).slides }
  end

end

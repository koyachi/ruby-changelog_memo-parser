#require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
$:.unshift File.dirname(__FILE__)

require 'changelog_memo-parser'

describe 'ChangelogMemo::Parser' do
  let(:input_text) do
    <<-TEXT
2012-03-13 (Tue)  t.koyachi@home  <sample@test.com>

	* tag1: title1
	body-line1
	body-line2

2012-03-12 (Mon)  t.koyachi@home  <sample@test.com>

	* tag2: title2
	body2-line1

	* tag3_1, tag3_2: title3
	body3-line1
	body3-line2

TEXT
  end

  it 'should parse_text' do
    ChangelogMemo::Parser.parse_text(input_text).should ==(
      [
        ChangelogMemo::Entry.new("title1", "body-line1\nbody-line2", ["tag1"], "2012-03-13"),
        ChangelogMemo::Entry.new("title2", "body2-line1", ["tag2"], "2012-03-12"),
        ChangelogMemo::Entry.new("title3", "body3-line1\nbody3-line2", ["tag3_1", "tag3_2"], "2012-03-12"),
      ])
  end

  let(:clmemo_file_path) { File.expand_path(File.dirname(__FILE__) + '/fixture/clmemo.txt') }
  it 'should parse_file' do
    ChangelogMemo::Parser.parse_file(clmemo_file_path).should ==(
      [
        ChangelogMemo::Entry.new("title1 from clmemo.txt", "body-line1\nbody-line2", ["tag1"], "2012-03-13"),
        ChangelogMemo::Entry.new("title2 from clmemo.txt", "body2-line1", ["tag2"], "2012-03-12"),
        ChangelogMemo::Entry.new("title3 from clmemo.txt", "body3-line1\nbody3-line2", ["tag3_1", "tag3_2"], "2012-03-12"),
        ChangelogMemo::Entry.new("title4 from clmemo.txt", "body4-line1", ["tag4_1"], "2012-03-12"),
      ])
  end
end

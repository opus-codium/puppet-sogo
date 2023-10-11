# frozen_string_literal: true

require 'spec_helper'

describe 'sogo::to_plist' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params('').and_return('""') }
  it { is_expected.to run.with_params(true).and_return('YES') }
  it { is_expected.to run.with_params(false).and_return('NO') }
  it { is_expected.to run.with_params('one').and_return('"one"') }
  it { is_expected.to run.with_params(42).and_return('42') }
  it { is_expected.to run.with_params('42').and_return('"42"') }
  it { is_expected.to run.with_params([], 0).and_return("(\n)") }
  it { is_expected.to run.with_params(['one'], 0).and_return(%{(\n  "one",\n)}) }
  it { is_expected.to run.with_params(%w[one two], 0).and_return(%{(\n  "one",\n  "two",\n)}) }
  it { is_expected.to run.with_params({}, 0).and_return("{\n}") }
  it { is_expected.to run.with_params({ 'key' => 'value' }, 0).and_return(%({\n  key = "value";\n})) }

  it {
    expect(subject).to run.with_params(
      [
        {
          type: 'ldap',
        },
        {
          type: 'sql',
        },
      ],
      0
    ).and_return(<<~RESULT.chomp)
      (
        {
          type = "ldap";
        },
        {
          type = "sql";
        },
      )
    RESULT
  }

  it {
    expect(subject).to run.with_params({ 'one' => { 'oneA' => 'A', 'oneB' => { 'oneB1' => '1', 'oneB2' => '2' } }, 'two' => %w[twoA twoB] }, 0).
      and_return(<<~RESULT.chomp)
        {
          one = {
            oneA = "A";
            oneB = {
              oneB1 = "1";
              oneB2 = "2";
            };
          };
          two = (
            "twoA",
            "twoB",
          );
        }
      RESULT
  }
end

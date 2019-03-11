require 'active_support/all'

require 'mumukit/bridge'

describe 'runner' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4567') }
  before(:all) do
    @pid = Process.spawn 'rackup -p 4567', err: '/dev/null'
    sleep 3
  end
  after(:all) { Process.kill 'TERM', @pid }

  let(:test) do
    <<HASKELL
it "x" $ do
  x `shouldBe` 1
HASKELL
  end

  let(:unicode_string) do
    "¿No gusta pasar a tomar una tacita de ☕? ¿No será mucha molestia?"
  end

  let(:test_unicode) do
    <<HASKELL
it "#{unicode_string}" $ do
  x `shouldBe` 1
HASKELL
  end

  let(:ok_content) do
    <<HASKELL
x = 1
HASKELL
  end

  let(:nok_content) do
    <<HASKELL
x = 2
HASKELL
  end

  let(:malicius_content) do
    <<HASKELL
import System.IO.Unsafe

x = 1
HASKELL
  end

  it 'answers a valid hash when query is ok' do
    response = bridge.run_query!(extra: "f x = x",
                                 content: "g x = x",
                                 query: 'f 1 + g 2')
    expect(response).to eq(status: :passed, result: "3")
  end

  it 'answers a valid hash when submission is ok' do
    response = bridge.run_tests!(test: test,
                                 extra: '',
                                 content: ok_content,
                                 expectations: [{binding: '', inspection: 'Except:HasTooShortIdentifiers'}])

    expect(response).to eq(response_type: :structured,
                           test_results: [{title: 'x', status: :passed, result: ''}],
                           status: :passed,
                           feedback: '',
                           expectation_results: [],
                           result: '')
  end

  it 'answers a valid hash when submission has warnigns' do
    response = bridge.run_tests!(test: test,
                                 extra: '',
                                 content: ok_content,
                                 expectations: [])

    expect(response).to eq(response_type: :structured,
                           test_results: [{title: 'x', status: :passed, result: ''}],
                           status: :passed_with_warnings,
                           feedback: '',
                           expectation_results: [{binding: 'x', inspection: 'HasTooShortIdentifiers', result: :failed}],
                           result: '')
  end

  it 'answers a valid hash when submission is not ok' do
    response = bridge.run_tests!(test: test,
                                 extra: '',
                                 content: nok_content,
                                 expectations: [])

    expect(response).to eq(response_type: :structured,
                           test_results: [{title: 'x', status: :failed, result: "expected: 1\n but got: 2"}],
                           status: :failed,
                           feedback: '',
                           expectation_results: [{binding: 'x', inspection: 'HasTooShortIdentifiers', result: :failed}],
                           result: '')
  end


  it 'answers a valid hash when submission is not ok and ends in comment' do
    response = bridge.run_tests!(test: test,
                                 extra: '',
                                 content: "#{nok_content}\n-- dsds",
                                 expectations: [])

    expect(response).to eq(response_type: :structured,
                           test_results: [{title: 'x', status: :failed, result: "expected: 1\n but got: 2"}],
                           status: :failed,
                           feedback: '',
                           expectation_results: [{binding: 'x', inspection: 'HasTooShortIdentifiers', result: :failed}],
                           result: '')
  end


  it 'answers a valid hash when submission is invalid' do
    response = bridge.run_tests!(test: test,
                                 extra: '',
                                 content: malicius_content,
                                 expectations: [])

    expect(response).to eq(response_type: :unstructured,
                           status: :aborted,
                           feedback: '',
                           expectation_results: [],
                           test_results: [],
                           result: 'you can not use unsafe io')
  end

  describe 'Unicode characters support' do
    it 'works OK with queries' do
      response = bridge.run_query!(extra: "",
                                   content: "",
                                   query: "\"#{unicode_string}\"")

      expect(response).to eq(status: :passed, result: "\"#{unicode_string}\"")
    end

    it 'works OK with submissions' do
      response = bridge.run_tests!(test: test_unicode,
                                   extra: '',
                                   content: ok_content,
                                   expectations: [])

      expect(response[:test_results].first[:title]).to eq unicode_string
    end
  end
end

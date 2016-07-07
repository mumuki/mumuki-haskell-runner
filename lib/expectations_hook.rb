require 'json'

class HaskellExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include_smells true

  def compile(request)
    request[:expectations] = request[:expectations].map do |it|
      {tag: :Basic}.merge(it)
    end
    request
  end

  def transform_content(content)
    content
  end

  def make_response(response)
    response['results'].map do |it|
      {result: it['result'],
       expectation: {
           inspection: it['expectation']['inspection'],
           binding: it['expectation']['binding']}}
    end
  end


  def language
    'Haskell'
  end
end

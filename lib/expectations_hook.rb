require 'json'

class HaskellExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include_smells true

  def language
    'Haskell'
  end
end

class MetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'haskell',
        icon: {type: 'devicon', name: 'haskell'},
        version: 'ghc-7.10.1',
        extension: 'hs',
        ace_mode: 'haskell'
    },
     test_framework: {
         name: 'hspec',
         version: '2',
         test_extension: 'hs'
     }}
  end
end
class HaskellMetadataHook < Mumukit::Hook
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
         test_extension: 'hs',
         template: <<haskell
describe "{{ test_template_group_description }}" $ do 
  
  it "{{ test_template_sample_description }}" $ do
    True `shouldBe` True
haskell
     }}
  end
end
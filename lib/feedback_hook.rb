class HaskellFeedbackHook < Mumukit::Hook
  def run!(request, results)
    HaskellExplainer.new.explain(request.content, results.test_results[0])
  end

  class HaskellExplainer < Mumukit::Explainer
    def explain_type_error(_, test_results)
      regexp = /Couldn't match type 8216(.*)8217 with 8216(.*)8217\n    Expected type: (.*)\n      Actual type: (.*)\n    In the expression: (.*)\n    In an equation for 8216x8217: (.*)\(deferred type error\)/
      (regexp.match test_results).try do |it|
        {fragment: it[0],
        expression: it[5],
        actual: it[4],
        expected: it[3]}
      end
    end
  end
end




require_relative '../lib/hspec_server2'
require 'ostruct'

def treq(content='', test='', extra='')
  OpenStruct.new(content: content, test: test, extra: extra)
end

def qreq(content='', query='', extra='')
  OpenStruct.new(content: content, query: query, extra: extra)
end
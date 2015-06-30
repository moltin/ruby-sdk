require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Codecov,
]
SimpleCov.start do
  add_filter 'spec'
  add_group 'API', '/lib/moltin/api'
  add_group 'Rails', '/lib/moltin/rails'
  add_group 'Resource', '/lib/moltin/resource'
  add_group 'Support', '/lib/moltin/support'
end

Pry.config.editor = 'sublime'

# Prompt with ruby version
Pry.prompt = [proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " }, proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }]

# loading rails configuration if it is running as a rails console
# load File.dirname(__FILE__) + '/.railsrc' if defined?(Rails) && Rails.env

Pry.config.editor = 'sublime'

# Prompt with ruby version
Pry.prompt = [proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " }, proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }]

# loading rails configuration if it is running as a rails console
# load File.dirname(__FILE__) + '/.railsrc' if defined?(Rails) && Rails.env

if defined?(PryDebugger)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

begin
  require "awesome_print"
  AwesomePrint.pry!
rescue LoadError
  nil
end

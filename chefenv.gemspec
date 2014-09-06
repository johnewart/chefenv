$:.unshift(File.dirname(__FILE__) + '/lib')
require 'chefenv/version'

Gem::Specification.new do |s|
  s.name = 'chefenv'
  s.version = ChefEnv::VERSION
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ['README.md', 'CHANGELOG.md', 'LICENSE' ]
  s.summary = 'A tool for managing multiple Chef environments (URLs, node names, keys, etc.)'
  s.description = s.summary
  s.author = 'John Ewart'
  s.email = 'jewart@getchef.com'
  s.homepage = 'http://github.com/johnewart/chefenv'

  s.add_dependency 'thor', '~> 0.19.1'  

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'

  s.bindir       = "bin"
  s.executables  = %w( chefenv )

  s.require_path = 'lib'
  s.files = %w(Rakefile LICENSE README.md CHANGELOG.md) + Dir.glob("{distro,lib,tasks,spec}/**/*", File::FNM_DOTMATCH).reject {|f| File.directory?(f) }
end

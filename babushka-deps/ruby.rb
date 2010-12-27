# Here we define all dependencies, which have to do with ruby and gems
dep 'ruby_with_gems' do
	requires '1.9.2.rvm', 'rake.gem', 'bundler.gem', 'capistrano.gem'
end

dep 'rake.gem' do
	requires '1.9.2.rvm'
  installs 'rake 0.8.7'
	provides 'rake'
end

dep 'bundler.gem' do
	requires '1.9.2.rvm'
  installs 'bundler 1.0.7'
  provides 'bundle'
end

dep 'capistrano.gem' do
	requires '1.9.2.rvm'
	installs 'capistrano'
	provides 'cap'
end

meta :rvm do
  template {
		requires 'rvm'

    def rvm(args) 
      shell "rvm #{args}", :log => args['install']
    end

		def ruby_version; '1.9.2-p136'; end 							# rvm  uses ruby-1.9.2-p136
		def ruby_ruby_version; '1.9.2p136'; end						# ruby uses ruby 1.9.2 p136
  }
end

dep '1.9.2.rvm' do
  requires '1.9.2 installed.rvm'
  met? { shell('ruby --version')["ruby #{ruby_ruby_version}"] }
  meet { rvm("use #{ruby_version} --default") }
end

dep '1.9.2 installed.rvm' do
  requires 'rvm'

  met? { rvm('list')["ruby-#{ruby_version}"] }
	meet :on => :osx   do log("rvm install #{ruby_version}") { shell "~/.rvm/bin/rvm #{ruby_version}" } end
	meet :on => :linux do log("rvm install #{ruby_version}") { shell "rvm install #{ruby_version}", :sudo => true } end
end

dep 'rvm' do
	prepare { shell "source /usr/local/rvm/scripts/rvm" }
  met? { raw_which 'rvm', shell('which rvm') }
	meet { log("You must install rvm manually first, using a system-wide install!") }
end

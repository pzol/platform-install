meta :rvm do
  template {
		requires 'rvm'

    def rvm(args)
      shell "rvm #{args}", :log => args['install']
    end

		def ruby_version; '1.9.2-p180'; end 							# rvm  uses ruby-1.9.2-p136
		def ruby_ruby_version; '1.9.2p180'; end						# ruby uses ruby 1.9.2 p136
  }
end

dep '1.9.2.rvm' do
  requires '1.9.2 installed.rvm'
  met? { shell('ruby --version')["ruby #{ruby_ruby_version}"] }
  meet { rvm("use #{ruby_version} --default") }
end

dep '1.9.2 installed.rvm' do
  requires 'rvm', 'rvm_1.6.9'

  met? { rvm('list')["ruby-#{ruby_version}"] }
	meet :on => :osx   do log("rvm install #{ruby_version}") { shell "~/.rvm/bin/rvm #{ruby_version}" } end
	meet :on => :linux do log("rvm install #{ruby_version}") { shell "rvm package install readline; rvm install #{ruby_version} --with-readline-dir=$rvm_path/usr", :sudo => true } end
end

dep 'rvm' do
  met? { which 'rvm' }
	meet { log("You must install rvm manually first, using a system-wide install!") }
end

dep 'rvm_1.6.9' do
  met? { shell('rvm -v | awk \'$0 != "" {print $2}\'')["1.6.9"] }
  meet { shell('rvm get head && rvm get 1.6.9 && rvm reload') }
end

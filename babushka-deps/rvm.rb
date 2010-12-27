meta :rvm do
  template {
    def rvm(args) 
      shell "rvm #{args}", :log => args['install']
    end
  }
end

dep '1.9.2.rvm' do
  requires '1.9.2 installed.rvm'
  met? { shell('ruby --version')['ruby 1.9.2p136'] }
  meet { rvm('use 1.9.2 --default') }
end

dep '1.9.2 installed.rvm' do
  requires 'rvm'

  met? { rvm('list')['ruby-1.9.2-p136'] }
	meet :on => :osx   do log("rvm install 1.9.2") { shell '~/.rvm/bin/rvm install 1.9.2' } end
	meet :on => :linux do log("rvm install 1.9.2") { shell 'rvm install 1.9.2', :sudo => true } end
end

dep 'rvm' do
  met? { raw_which 'rvm', shell('which rvm') }
	meet { log("You must install rvm manually first, using a system-wide install!") }
end

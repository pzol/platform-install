Dir.glob('/opt/**/*/**/config/god.rb').select {|f| f =~ /current/}.each {|f| load f}

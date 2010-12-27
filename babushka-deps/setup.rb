meta :setup do
  accepts_list_for :source
  accepts_list_for :extra_source
  accepts_list_for :provides, :default_name
  accepts_value_for :prefix

  def default_name
    Babushka::VersionOf.new basename
  end

  accepts_block_for :preconfigure
  accepts_block_for :install
	accepts_block_for(:postconfigure) {
		Dir.glob(var(:prefix, :default => prefix) / "bin/*").each do |bin|
			shell "ln -s #{bin} /usr/local/bin/#{File.basename(bin)}", :sudo => true
		end
	}

  accepts_block_for(:process_source) {
    call_task(:preconfigure) and
    call_task(:install) # and 
		call_task(:postconfigure)
  }

  template {
    prepare { setup_source_uris }
    met? { provided? }
    meet { process_sources { call_task :process_source } }
  }
end

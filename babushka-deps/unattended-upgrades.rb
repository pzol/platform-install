require 'ftools'

dep "unattended-upgrades" do
  requires 'unattended-upgrades.managed', "unattended-upgrades-50unattended-config", "unattended-upgrades-10periodic-config", "unattended-upgrades-50unattended-modificationrem", "unattended-upgrades-50unattended-modificationUNrem"
end

dep "unattended-upgrades-50unattended-config" do
  met? { File.exists?("/etc/apt/apt.conf.d/50unattended-upgrades") }
  meet { render_erb "unattended-upgrades/50unattended-upgrades", :to => "/etc/apt/apt.conf.d/50unattended-upgrades", :sudo => true }
end

dep "unattended-upgrades-10periodic-config" do
  met? { File.exists?("/etc/apt/apt.conf.d/10periodic") }
  meet { render_erb "unattended-upgrades/10periodic", :to => "/etc/apt/apt.conf.d/10periodic", :sudo => true }
end

dep "unattended-upgrades-50unattended-modificationrem" do
  met? do
          retval = true
          File.open('/etc/apt/apt.conf.d/50unattended-upgrades').each_line do |line|
            if 
              line =~ /distro_id/ and line !~ /^\w*\/{2}/ and line !~ /security/
              if line != nil
                retval = false
                break
              end
            end
          end
        retval
      end
  meet do
          lines = IO.readlines('/etc/apt/apt.conf.d/50unattended-upgrades')
          lines.each do |line|
            if line =~ /distro_id/ and line !~ /^\w*\/{2}/ and line !~ /security/
                line.insert(0, "//")
            end
          end
          File.open('/etc/apt/apt.conf.d/50unattended-upgrades',"w") do |f|
            f.write(lines.to_s)
          end
       end
end

dep "unattended-upgrades-50unattended-modificationUNrem" do
  met? do
          retval = true
          File.open('/etc/apt/apt.conf.d/50unattended-upgrades').each_line do |line|
            if 
              line =~ /distro_id/ and line =~ /^\w*\/{2}/ and line =~ /security/
              if line != nil
                retval = false
                break
              end
            end
          end
        retval
      end
  meet do
          lines = IO.readlines('/etc/apt/apt.conf.d/50unattended-upgrades')
          lines.each do |line|
            if line =~ /distro_id/ and line =~ /^\w*\/{2}/ and line =~ /security/
                line.tr!('//','')
            end
          end
          File.open('/etc/apt/apt.conf.d/50unattended-upgrades',"w") do |f|
            f.write(lines.to_s)
          end
       end
end

dep 'unattended-upgrades.managed'

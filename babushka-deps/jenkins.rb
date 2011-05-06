dep 'jenkins.src' do
  source "http://pkg.jenkins-ci.org/debian/binary/jenkins_1.412_all.deb"
  process_source {
    sudo("dpkg -i jenkins_1.412_all.deb")
  }
  met? { File.exists? "/etc/init.d/jenkins" }
end

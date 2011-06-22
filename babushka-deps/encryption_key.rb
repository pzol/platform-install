dep 'encryption_key.directory_exists' do
  met? { File.exists?("/home/deploy/encryption_key") && File.directory?("/home/deploy/encryption_key") }
  meet { shell 'mkdir /home/deploy/encryption_key' }
end

dep 'encryption_key.key_exists' do
  met? { File.exists?("/home/deploy/encryption_key/aeskey") }
  meet 
  begin
    shell 'openssl enc -aes-256-cbc -k secret -P -md sha1 >> "/home/deploy/encryption_key/aeskey"'
    shell 'chmod 400 "/home/deploy/encryption_key/aeskey"'
  end
end

dep 'encryption_key' do
  requires 'encryption_key.directory_exists', 'encryption_key.key_exists'
end

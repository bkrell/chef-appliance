# download and copy source zip
script 'download_and_copy' do
  interpreter "bash"
  cwd '/tmp/'
  code <<-EOH
    wget https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip
    unzip master.zip
    cd Awesome-Appliance-Repair-master
    sudo mv AAR /var/www/
    EOH
  not_if { ::File.exists?'/var/www/AAR/awesomeapp.py' }
end

# problem with install script is getpass prompt so replace it
execute 'stub out the getpass prompt' do
  cwd '/tmp/Awesome-Appliance-Repair-master'
  command "sudo sed -ibak s/getpass\\\\./\\'#{node['wsappliance']['sqlroot']}\\'#/g AARinstall.py"
  not_if { ::File.exists?'/tmp/Awesome-Appliance-Repair-master/AARinstall.pybak'}
end

# now run the python script, unless already installed (look for config file)
execute 'install AAR app' do
  cwd '/tmp/Awesome-Appliance-Repair-master/'
  command 'sudo python AARinstall.py'
  notifies :restart, 'service[apache2]'
  not_if { ::File.exists?'/etc/apache2/sites-enabled/AAR-apache.conf' }
end

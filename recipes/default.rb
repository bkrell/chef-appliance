include_recipe 'apt::default'

# install the prerequisite packages
# python script will configure, so just use the default installs
package 'apache2'
package 'mysql-server'
package 'unzip'

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
execute "sudo sed -ibak s/getpass\\\\./\\'\\'#/g /tmp/Awesome-Appliance-Repair-master/AARinstall.py"

# now run the python script, unless already installed (look for config file)
execute 'install AAR app' do
  cwd '/tmp/Awesome-Appliance-Repair-master/'
  command 'sudo python AARinstall.py'
  not_if { ::File.exists?'/etc/apache2/sites-enabled/AAR-apache.conf' }
end

# restart apache for changes to take effect
service 'apache2' do
  action :restart
end

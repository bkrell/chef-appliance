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

# can't just use execute here because it is not idempotent
# need guards, e.g. not_if, also try script block instead of execute
#execute 'wget https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip'

# install the prerequisite packages
# python script will configure, so just use the default installs
package 'unzip'
package 'apache2'
package 'mysql-server' do
  action :install
  notifies :run, 'execute[setmysqlrootpwd]', :immediately
end

# ensure services are up on each chef-client run
service 'apache2' do
  action [:enable, :start]
end
service 'mysql' do
  action [:enable, :start]
end

# only run this when the mysql-server package is installed
execute 'setmysqlrootpwd' do
  command "mysqladmin -u root password #{node['wsappliance']['sqlroot']}"
  action :nothing
end

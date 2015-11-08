include_recipe 'apt::default'

# install the prerequisite packages
# python script will configure, so just use the default installs
package 'apache2'
package 'mysql-server'
package 'unzip'

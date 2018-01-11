require 'serverspec'
require 'winrm'

#require 'chefspec'
#require 'chefspec/berkshelf'

set :os, :family => 'windows'
set :backend, :cmd
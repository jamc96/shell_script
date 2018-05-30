# include class
include ::shell_script
# create resource
::shell_script::permission { 'foo':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '775',
  path   => '/tmp/test',
}

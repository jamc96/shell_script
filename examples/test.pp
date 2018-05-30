# Class: shell_script
# testing hash
$permission_scripts = { 'foo' => {
                          'ensure' => 'present',
                          'owner'  => 'root',
                          'group'  => 'root',
                          'mode'   => '775',
                          'path'   => '/tmp/test',
                        },
                        'bar' => {
                          'ensure' => 'present',
                          'owner'  => 'root',
                          'group'  => 'root',
                          'mode'   => '700',
                          'path'   => '/tmp/test1',
                        },
                      }
# class parameters
class { '::shell_script':
  permission_scripts => $permission_scripts,
}

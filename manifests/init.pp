# shell_script
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include shell_script
class shell_script(
  Optional[Hash] $permission_scripts = undef,
  String $conf_dir                   = '/root/permission',
) {
  # create main directory
  file { $conf_dir:
    ensure => 'directory',
  }
  # create resource scripts
  if $permission_scripts {
    create_resources(shell_script::permission, $permission_scripts)
  }
}

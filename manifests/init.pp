# shell_script
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include shell_script
class shell_script(
  Hash $permission_scripts,
  String $path = '/root',
  String $owner = 'root',
  String $group = 'root',
  String $mode  = '0500'
) {
  # create resource scripts
  if $permission_scripts {
    create_resource(shell_script::permission, $permission_scripts)
  }
}

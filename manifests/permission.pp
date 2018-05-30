# shell_script::permission
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   shell_script::permission { 'namevar': }
define shell_script::permission(
  $ensure,
  $owner,
  $group,
  $mode,
  $path,
) {
  # global variables
  $script_path = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  $file_path  = $::shell_script::use_path

  case $facts['os']['name'] {
    'CentOS': {
      $shell_path = $facts['operatingsystemmajrelease'] ?
        '7' => '/usr/bin/sh',
        default => '/bin/sh',
      }
    default: {
      $shell_path = '/bin/sh'
    }
  }
  # create script
  file { $name:
    ensure       => $ensure,
    owner        => $::shell_script::use_owner,
    group        => $::shell_script::use_group,
    mode         => $::shell_script::use_mode,
    path         => "${file_path}/${name}.sh",
    content      => template("${module_name}/permission.erb"),
    notify       => Exec["script ${name}.sh"]
    validate_cmd => "${shell_path} -n %",
  }
  exec { "script ${name}.sh":
    command     => "sh /root/${name}.sh",
    refreshonly => true,
    path        => $script_path,
  }
}


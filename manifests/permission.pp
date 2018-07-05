# shell_script::permission
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   shell_script::permission { 'namevar': }
define shell_script::permission(
  Optional[String] $path           = undef,
  Enum['present','absent'] $ensure = 'present',
  String $owner                    = 'root',
  String $group                    = 'root',
  String $mode                     = '644',
  String $conf_dir                 = '/root/permission',
) {
  # global variables
  unless $path {
    fail("Defined Type[shell_script::permission]: parameter 'path' expects a match for string value")
  }
  case $facts['os']['name'] {
    'CentOS': {
      $shell_path = $facts['operatingsystemmajrelease'] ? {
        '7' => '/usr/bin/sh',
        default => '/bin/sh',
      }
    }
    default: {
      $shell_path = '/bin/sh'
    }
  }
  # create main directory
  file { $conf_dir:
    ensure => 'directory',
  }
  # create script
  file { "${conf_dir}/${name}.sh":
    ensure       => $ensure,
    owner        => 'root',
    group        => 'root',
    mode         => '0500',
    content      => template("${module_name}/permission.erb"),
    validate_cmd => "${shell_path} -n %",
    require      => File[$conf_dir],
  }
  exec { "${conf_dir}/${name}.sh":
    command     => "sh /root/${name}.sh",
    refreshonly => true,
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    subscribe   => File["${conf_dir}/${name}.sh"],
  }
}

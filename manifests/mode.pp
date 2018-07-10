# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   shell_script::mode { 'namevar': }
define shell_script::mode(
  Optional[Array] $path            = undef,
  Enum['present','absent'] $ensure = 'present',
  Optional[String] $mode           = undef,
  String $conf_dir                 = '/root/scripts',
) {
  # global variables
  unless $path {
    fail("Defined Type[shell_script::mode]: parameter 'path' expects a match for string value")
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
  # create script
  file { "${conf_dir}/${name}.sh":
    ensure       => $ensure,
    owner        => 'root',
    group        => 'root',
    mode         => '0500',
    content      => template("${module_name}/mode.erb"),
    validate_cmd => "${shell_path} -n %",
  }
  exec { "${conf_dir}/${name}.sh":
    command     => "sh ${conf_dir}/${name}.sh",
    refreshonly => true,
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    subscribe   => File["${conf_dir}/${name}.sh"],
  }
}

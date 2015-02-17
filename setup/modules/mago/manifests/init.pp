class mago ($target, $root_dir, $user, $group) {


    $source_dir = "${root_dir}/source"
    $log_dir    = "${root_dir}/log"
    $run_dir    = "${root_dir}/run"
    $extras_dir = "${root_dir}/extras"
    $data_dir   = "${root_dir}/data"
    $cache_dir  = "${root_dir}/cache"
    $venv_dir   = "${root_dir}/venv"
    $app_dir    = "${source_dir}/app"
    $env        = "${target}"

    Exec {
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
    }

    class { 'apt':
        always_apt_update => true;
    }

    group { $group:
        ensure => present;
    }

    if $user != $group {

        user { $user:
            ensure     => present,
            managehome => true,
            shell      => '/bin/bash',
            groups     => [$group],
            require    => Group[$group];
        }

    } else {

        notify{"User and Group are the same": }

        user { $user:
            ensure     => present,
            managehome => true,
            shell      => '/bin/bash',
            gid        => $user,
            require    => Group[$group];
        }

    }


    file {
        $root_dir:
            owner   => $user,
            group   => $group,
            ensure  => directory,
            require => User[$user];
        $log_dir:
            owner   => $user,
            group   => $group,
            ensure  => directory,
            require => [File[$root_dir], User[$user]];
        $run_dir:
            owner   => $user,
            group   => $group,
            ensure  => directory,
            require => [File[$root_dir], User[$user]];
        $data_dir:
            owner   => $user,
            group   => $group,
            ensure  => directory,
            require => [File[$root_dir], User[$user]];
        $cache_dir:
            owner   => $user,
            group   => $group,
            ensure  => directory,
            require => [File[$root_dir], User[$user]];
        $extras_dir:
            owner   => $user,
            group   => $group,
            ensure  => directory,
            require => [File[$root_dir], User[$user]];
    }

    notify{"template is ${module_name}/bashrc.erb": }

    file { "/home/${user}/.bashrc":
        ensure => present,
        owner   => $user,
        group   => $group,
        mode    => '755',
        content => template("${module_name}/bashrc.erb"),
        require => User[$user];
    }

    if $target == 'dev' {
        file { $source_dir:
            owner   => $user,
            group   => $group,
            ensure  => directory,
            require => [File[$root_dir], User[$user]];
        }
    }

    if $target != 'dev' {
        class { 'mago::code':
            user       => $user,
            group      => $group,
            source_dir => $source_dir;
        }
    }

    package { 'ntp':
        ensure   => 'installed',
        provider => 'apt';
    }

    package { ['git-core', 'libpq-dev', 'make']:
        ensure   => installed,
        provider => 'apt';
    }

}

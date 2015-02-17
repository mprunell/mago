class mago::app::deploy {

    include mago::venv

    if $mago::target != 'dev' {

        file { "${mago::log_dir}/website.log":
            owner   => $mago::user,
            group   => $mago::group,
            ensure  => present,
        }

        file { "${mago::app_dir}/mago/settings/local.py":
            owner   => $mago::user,
            group   => $mago::group,
            ensure  => present,
            content => template("${module_name}/app/local.py.erb"),
            require => [File["${mago::log_dir}/website.log"],
                        Vcsrepo['source']];
        }

        file { "${mago::app_dir}/mago/settings/secrets.py":
            owner   => $mago::user,
            group   => $mago::group,
            ensure  => present,
            content => template("${module_name}/app/secrets.py.erb"),
            require => Vcsrepo['source'];
        }

        if $mago::target != 'pro' and $::mago_reset_db == 'true' {
            exec { 'mago::app::deploy::db':
                command   => "python manage.py reset_db --traceback",
                cwd       => $mago::app_dir,
                user      => $mago::user,
                group     => $mago::group,
                path      => "${mago::venv_dir}/bin",
                logoutput => "on_failure",
                require   => [File["${mago::app_dir}/mago/settings/secrets.py"],
                              Class["mago::venv"]];
            }
        } else {
            exec { 'mago::app::deploy::db':
                command   => "python manage.py syncdb --noinput --migrate --traceback",
                cwd       => $mago::app_dir,
                user      => $mago::user,
                group     => $mago::group,
                path      => "${mago::venv_dir}/bin",
                logoutput => "on_failure",
                require   => [File["${mago::app_dir}/mago/settings/secrets.py"],
                              Class["mago::venv"]];
            }
        }

        exec { "mago::app::deploy::collectstatic":
            command   => "python manage.py collectstatic --noinput",
            cwd       => $mago::app_dir,
            user      => $mago::user,
            group     => $mago::group,
            path      => "${mago::venv_dir}/bin",
            logoutput => "on_failure",
            require   => [File["${mago::app_dir}/mago/settings/secrets.py"],
                          Class["mago::venv"]];
        }
    }
}

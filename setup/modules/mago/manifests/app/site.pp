class mago::app::site {

    include mago::venv
    include nginx
    include supervisor

    nginx::vhost { "mago::app::site":
        name    => "mago_app",
        content => template("${module_name}/app/nginx.conf"),
        require => [Class["mago"], Class["nginx"]];
    }


    # If /etc/ntp.conf does not exist. Execute the command.
    exec { "mago::app::site::ensure_ntp_update_time":
        command => "ntpdate pool.ntp.org",
        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        creates => "/etc/ntp.conf",
        require => Package["ntp"];
    }

    if $mago::target != 'dev' {

        include uwsgi

        if $mago::target in ['local', 'sta'] {

            if $mago::target == 'local' {
                $settings = 'local'
            } elsif $mago::target == 'sta' {
                $settings = 'staging'
            }

            supervisor::app { "mago_app_site":
                command     => "/usr/local/bin/uwsgi
                                        --socket=${mago::run_dir}/app_uwsgi.sock
                                        --chmod-socket=666
                                        --processes=2
                                        --harakiri=120
                                        --max-requests=5000
                                        --master
                                        --vacuum
                                        --virtualenv=${mago::venv_dir}
                                        --pp=${mago::app_dir}
                                        --module=mago.wsgi:application",
                environment => "DJANGO_SETTINGS_MODULE='mago.settings'",
                user        => $mago::user,
                require     => [Class["mago::venv"],
                                Class["mago"],
                                Class["mago::app::deploy"]],
                stdout_logfile => "${mago::log_dir}/app_stdout.log",
                stderr_logfile => "${mago::log_dir}/app_stderr.log";
            }

            exec { "app_restart":
                 command => "/usr/bin/supervisorctl restart mago_app_site",
                 require => Supervisor::App["mago_app_site"];
            }

        } else {

            if $mago::target == 'pro' {
              $settings = 'production'
            } elsif $mago::target == 'sta' {
              $settings = 'staging'
            }
            supervisor::app { "app_site":
                command     => "/usr/local/bin/uwsgi
                                        --socket=${mago::run_dir}/app_uwsgi.sock
                                        --chmod-socket=666
                                        --processes=2
                                        --harakiri=120
                                        --max-requests=5000
                                        --master
                                        --vacuum
                                        --virtualenv=${mago::venv_dir}
                                        --pp=${mago::app_dir}
                                        --module=mago.wsgi:application",

                environment => "DJANGO_SETTINGS_MODULE='mago.settings.${settings}',NEW_RELIC_CONFIG_FILE='${mago::data_dir}/newrelic.ini'",
                user        => $mago::user,
                require     => [Class["mago::app::deploy"]],
                stdout_logfile => "${mago::log_dir}/app_site_stdout.log",
                stderr_logfile => "${mago::log_dir}/app_site_stderr.log";
            }

            exec { "app_site_restart":
                 command => "/usr/bin/supervisorctl restart app_site",
                 require => Supervisor::App["app_site"];
            }

        }
    }

}

class master {

    $target = $::mago_target
    $root_dir = "/home/mago/mago"
    $user = "mago"
    $group = "mago"

    host {
        "mago.app.db":
            ip => $::mago_app_db_address;
        "mago.app.cache":
            ip => $::mago_app_cache_address;
    }

    class { "mago":
        target => $target,
        root_dir => $root_dir,
        user => $user,
        group => $group;
    }

    class { "mago::app::site": }

    class { "mago::app::deploy": }

}

class { "master": }

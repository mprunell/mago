class dev {

    $target = "dev"
    $root_dir = "/home/vagrant/mago"
    $user = "vagrant"
    $group = "vagrant"

    host {
        "mago.app.db":
            ip => "127.0.0.1";
    }

    class { "mago":
        target => $target,
        root_dir => $root_dir,
        user => $user,
        group => $group;
    }

    class { "mago::app::site": }

}

class { "dev": }

class mago::app::db () {

	class { 'sqlite': }

    sqlite::db { "mago_app":
	    user    => 'mago',
	    group   => 'mago';
    }

}

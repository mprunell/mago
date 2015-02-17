class mago::venv {

    if $mago::target == 'local' {
      $settings = 'local'
    } elsif $mago::target == 'pro' {
      $settings = 'production'
    } elsif $mago::target == 'sta' {
      $settings = 'staging'
    } elsif $mago::target == 'test' {
      $settings = 'test'
    } else {
      $settings = 'development'
    }

    python::venv { $mago::venv_dir:
        requirements => "${mago::source_dir}/requirements/${settings}.pip",
        user         => $mago::user,
        group        => $mago::group,
        require      => [Class["mago"]];
    }

}

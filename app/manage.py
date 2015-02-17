#!/usr/bin/env python
import os
import sys

ENV_NAME = 'MAGO_ENV'

if __name__ == "__main__":
    env = os.environ.get(ENV_NAME)
    if env:
        os.environ.setdefault('DJANGO_SETTINGS_MODULE',
                              'mago.settings.{0}'.format(
                                  os.environ.get(ENV_NAME))
                              )
    else:
        os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mago.settings')

    from django.core.management import execute_from_command_line
    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    env = os.environ.get(ENV_NAME)
    if env:
        os.environ.setdefault('DJANGO_SETTINGS_MODULE',
                              'fulcrum.settings.{0}'.format(
                                  os.environ.get(ENV_NAME))
                              )
    else:
        os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'fulcrum.settings')

    from django.core.management import execute_from_command_line
    execute_from_command_line(sys.argv)

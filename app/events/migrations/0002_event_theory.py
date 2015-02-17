# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('events', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='event',
            name='theory',
            field=models.CharField(default=b'FR', max_length=2, choices=[(b'FR', b'French'), (b'UY', b'Uruguayan')]),
            preserve_default=True,
        ),
    ]

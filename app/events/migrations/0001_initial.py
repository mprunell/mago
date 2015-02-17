# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('date_label', models.CharField(max_length=100)),
                ('number', models.IntegerField(null=True, blank=True)),
                ('headline', models.TextField()),
                ('main_content', models.TextField()),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]

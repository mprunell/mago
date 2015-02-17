from django.db import models


class Event(models.Model):

    FRENCH = 'FR'
    URUGUAYAN = 'UY'
    THEORY_CHOICES = (
        (FRENCH, 'French'),
        (URUGUAYAN, 'Uruguayan'),
    )

    theory = models.CharField(max_length=2,
                              choices=THEORY_CHOICES,
                              default=FRENCH)
    date_label = models.CharField(max_length=100)
    number = models.IntegerField(blank=True, null=True)
    headline = models.TextField()
    main_content = models.TextField()

    def is_french(self):
        return self.theory == Event.FRENCH

    def save(self, *args, **kwargs):
        if not self.number:
            last_event = Event.objects.all().order_by('-number').first()
            if not last_event:
                self.number = 1
            else:
                self.number = last_event.number + 1

        return super(Event, self).save(*args, **kwargs)

    def __unicode__(self):
        return self.headline
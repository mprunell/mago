from django.conf.urls import patterns, url
from events.views import ListEventView

urlpatterns = patterns(
    '',
    url(
        r'^$',
        ListEventView.as_view(),
        name='events'
    ),
)
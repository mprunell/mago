from django.views.generic import ListView
from events.models import Event


class ListEventView(ListView):
    template_name = 'events/list.html'
    model = Event
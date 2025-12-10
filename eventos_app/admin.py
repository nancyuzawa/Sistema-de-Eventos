from django.contrib import admin

from django.contrib import admin
from .models import Evento
from django.contrib.auth.models import User

@admin.register(Evento)
class EventoAdmin(admin.ModelAdmin):
    list_display = ("nome", "data_inicio", "data_fim")
    search_fields = ("nome", "organizador__username")

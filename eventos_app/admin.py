from django.contrib import admin

# Register your models here.
from django.contrib import admin
from .models import Evento, Atividade
from django.contrib.auth.models import User

@admin.register(Evento)
class EventoAdmin(admin.ModelAdmin):
    list_display = ("nome", "data_inicio", "data_fim")
    search_fields = ("nome", "organizador__username")

@admin.register(Atividade)
class AtividadeAdmin(admin.ModelAdmin):
    list_display = ("titulo", "evento", "finalizada")
    list_filter = ("finalizada",)
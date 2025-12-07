from django import forms
from .models import Evento, Participante


class EventoForm(forms.ModelForm):
    class Meta:
        model = Evento
        fields = ['nome', 'descricao', 'data_inicio', 'data_fim']
        widgets = {
            'data_inicio': forms.DateTimeInput(attrs={'type': 'datetime-local'}),
            'data_fim': forms.DateTimeInput(attrs={'type': 'datetime-local'}),
        }

        def __init__(self, *args, **kwargs):
            super().__init__(*args, **kwargs)

            self.fields["data_inicio"].input_formats = ["%Y-%m-%dT%H:%M"]
            self.fields["data_fim"].input_formats = ["%Y-%m-%dT%H:%M"]


class ParticipanteForm(forms.ModelForm):
    class Meta:
        model = Participante
        fields = ["nome", "email", "telefone"]
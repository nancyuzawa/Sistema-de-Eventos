<<<<<<< Updated upstream
=======
from rest_framework import serializers
from .models import Evento

class EventoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Evento
        # 'fields' define o que será enviado para o Flutter e o que o Flutter pode enviar
        fields = ['id', 'nome', 'descricao', 'data_inicio', 'data_fim', 'organizador']
>>>>>>> Stashed changes

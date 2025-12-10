from rest_framework import serializers
from .models import Evento
from django.contrib.auth.models import User

class EventoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Evento
        fields = ['id', 'nome', 'descricao', 'data_inicio', 'data_fim', 'organizador']

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'password')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        # cria o usuário criptografando a senha
        user = User.objects.create_user(**validated_data)
        return user
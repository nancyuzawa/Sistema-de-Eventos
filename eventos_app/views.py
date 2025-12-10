from django.contrib.auth.models import User
from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required

from .models import Evento, Participacao, Participante, Atividade

from rest_framework import viewsets, generics, permissions
from .serializers import AtividadeSerializer, EventoSerializer, ParticipacaoSerializer, ParticipanteSerializer, UserSerializer

# cria automaticamente GET (Listar), POST (Criar), PUT (Atualizar), DELETE (Remover)
class EventoViewSet(viewsets.ModelViewSet):
    queryset = Evento.objects.all()
    serializer_class = EventoSerializer


class ParticipanteViewSet(viewsets.ModelViewSet):
    queryset = Participante.objects.all()
    serializer_class = ParticipanteSerializer

class ParticipacaoViewSet(viewsets.ModelViewSet):
    queryset = Participacao.objects.all()
    serializer_class = ParticipacaoSerializer

# Criar conta para logar no sistema
class UserCreate(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.AllowAny]

class AtividadeViewSet(viewsets.ModelViewSet):
    queryset = Atividade.objects.all()
    serializer_class = AtividadeSerializer
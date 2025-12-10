from django.contrib.auth.models import User
from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required

from .models import Evento

from rest_framework import viewsets, generics, permissions
from .serializers import EventoSerializer, UserSerializer

# cria automaticamente GET (Listar), POST (Criar), PUT (Atualizar), DELETE (Remover)
class EventoViewSet(viewsets.ModelViewSet):
    queryset = Evento.objects.all()
    serializer_class = EventoSerializer

# Criar conta para logar no sistema
class UserCreate(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.AllowAny]
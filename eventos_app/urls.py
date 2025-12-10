from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import AtividadeViewSet, EventoViewSet, ParticipacaoViewSet, ParticipanteViewSet, UserCreate
from rest_framework.authtoken.views import obtain_auth_token

router = DefaultRouter()
router.register(r'eventos', EventoViewSet)
router.register(r'participantes', ParticipanteViewSet)
router.register(r'inscricoes', ParticipacaoViewSet)
router.register(r'atividades', AtividadeViewSet)

urlpatterns = [
    # Rotas principais da API
    path("api/", include(router.urls)),
    
    # Rota de Login
    path('api-token-auth/', obtain_auth_token, name='api_token_auth'),
    
    # Rota de Cadastro de Usuário
    path('api/cadastro/', UserCreate.as_view(), name='account-create'),
]
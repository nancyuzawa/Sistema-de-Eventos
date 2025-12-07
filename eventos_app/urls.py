from django.shortcuts import render
from django.urls import path
from . import views
from .views import remover_participante, editar_participante

urlpatterns = [
    path("", views.lista_eventos, name="lista_eventos"),
    path("evento/<int:evento_id>/", views.evento_detalhe, name="evento_detalhe"),
    path('evento/novo/', views.novo_evento, name='novo_evento'),
    path("editar/<int:id>/", views.editar_evento, name="editar_evento"),
    path("excluir/<int:id>/", views.excluir_evento, name="excluir_evento"),


    path("evento/<int:evento_id>/inscrever/", views.inscrever_evento, name="inscrever_evento"),
    path("evento/<int:evento_id>/adicionar_participante/",views.adicionar_participante, name="adicionar_participante"),
    path("participacao/<int:participacao_id>/remover/", remover_participante, name="remover_participante"),
    path("participacao/<int:participacao_id>/editar/", editar_participante, name="editar_participante"),


    path("login/", views.login_view, name="login"),
    path("logout/", views.logout_view, name="logout"),
]


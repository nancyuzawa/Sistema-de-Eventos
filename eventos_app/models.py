
from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone


class Evento(models.Model):
    nome = models.CharField(max_length=200)
    descricao = models.TextField()
    data_inicio = models.DateTimeField()
    data_fim = models.DateTimeField()
    organizador = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.nome


#O organizador cadaastra o participante
class Participante(models.Model):
    nome = models.CharField(max_length=200)
    email = models.EmailField()
    telefone = models.CharField(max_length=20, blank=True)

    def __str__(self):
        return self.nome

#relaciona o entento ao participante
class Participacao(models.Model):
    participante = models.ForeignKey(Participante, on_delete=models.CASCADE)
    evento = models.ForeignKey(Evento, on_delete=models.CASCADE, related_name="participacoes")
    data_inscricao = models.DateTimeField(default=timezone.now)

    class Meta:
        unique_together = ("participante", "evento")






class Atividade(models.Model):
    evento = models.ForeignKey(Evento, on_delete=models.CASCADE, related_name="atividades")
    titulo = models.CharField(max_length=150)
    descricao = models.TextField(blank=True)
    finalizada = models.BooleanField(default=False)

    def __str__(self):
        return self.titulo
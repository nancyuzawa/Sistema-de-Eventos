from django.contrib.auth.models import User
from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required

from .models import Evento, Participacao, Participante
from django.contrib import messages
from .forms import EventoForm, ParticipanteForm


# LISTAGEM
@login_required
def lista_eventos(request):
    eventos = Evento.objects.filter(organizador=request.user)
    return render(request, 'eventos/lista_eventos.html', {'eventos': eventos})


# DETALHE
@login_required
def evento_detalhe(request, evento_id):
    evento = get_object_or_404(Evento, pk=evento_id, organizador=request.user)
    return render(request, "eventos/evento_detalhe.html", {"evento": evento})


# NOVO EVENTO
@login_required
def novo_evento(request):
    if request.method == "POST":
        form = EventoForm(request.POST)
        if form.is_valid():
            evento = form.save(commit=False)
            evento.organizador = request.user
            evento.save()
            return redirect("lista_eventos")
    else:
        form = EventoForm()

    return render(request, "eventos/novo_evento.html", {"form": form})

# EDITAR EVENTO
@login_required
def editar_evento(request, id):
    evento = get_object_or_404(Evento, id=id)

    if request.method == "POST":
        form = EventoForm(request.POST, instance=evento)
        if form.is_valid():
            form.save()
            return redirect("lista_eventos")
    else:
        form = EventoForm(instance=evento)

    return render(request, "eventos/editar_evento.html", {"form": form})


# EXCLUIR EVENTO
@login_required
def excluir_evento(request, id):
    evento = get_object_or_404(Evento, id=id)
    evento.delete()
    return redirect("lista_eventos")


def eventos_publicos(request):
    eventos = Evento.objects.all().order_by('data_inicio')
    return render(request, "eventos/eventos_publicos.html", {"eventos": eventos})

@login_required
def inscrever(request, evento_id):
    evento = get_object_or_404(Evento, pk=evento_id)
    Participacao.objects.get_or_create(evento=evento, usuario=request.user)
    return redirect("evento_detalhe", evento_id=evento_id)

def inscrever_evento(request, evento_id):
    if not request.user.is_authenticated:
        messages.error(request, "Você precisa estar logado para se inscrever.")
        return redirect("login")

    evento = get_object_or_404(Evento, id=evento_id)

    # Verifica se já está inscrito
    participacao, created = Participacao.objects.get_or_create(
        usuario=request.user,
        evento=evento
    )

    if not created:
        messages.warning(request, "Você já está inscrito neste evento.")
    else:
        messages.success(request, "Inscrição realizada com sucesso!")

    return redirect("detalhes_evento", evento_id=evento.id)


@login_required
def adicionar_participante(request, evento_id):
    evento = get_object_or_404(Evento, pk=evento_id, organizador=request.user)

    if request.method == "POST":
        nome = request.POST.get("nome")
        email = request.POST.get("email")
        telefone = request.POST.get("telefone")

        # Criar participante
        participante = Participante.objects.create(
            nome=nome,
            email=email,
            telefone=telefone
        )

        # Criar participação no evento
        Participacao.objects.create(
            participante=participante,
            evento=evento
        )

        return redirect("evento_detalhe", evento_id=evento.id)

    return render(request, "eventos/adicionar_participante.html", {"evento": evento})



def editar_participante(request, participacao_id):
    participacao = get_object_or_404(Participacao, id=participacao_id)
    participante = participacao.participante
    evento = participacao.evento

    if request.method == "POST":
        participante.nome = request.POST.get("nome")
        participante.email = request.POST.get("email")
        participante.telefone = request.POST.get("telefone")
        participante.save()
        return redirect("evento_detalhe", evento_id=evento.id)

    return render(request, "eventos/editar_participante.html", {
        "participacao": participacao,
        "participante": participante,
    })


def remover_participante(request, participacao_id):
    participacao = get_object_or_404(Participacao, id=participacao_id)

    evento_id = participacao.evento.id
    participacao.delete()

    return redirect("evento_detalhe", evento_id)





# LOGIN
def login_view(request):
    if request.method == "POST":
        username = request.POST.get("username", "")
        password = request.POST.get("password", "")
        user = authenticate(request, username=username, password=password)

        if user:
            login(request, user)
            return redirect("lista_eventos")
        else:
            return render(request, "eventos/login.html", {"error": "Credenciais inválidas."})

    return render(request, "eventos/login.html")


# LOGOUT
def logout_view(request):
    logout(request)
    return redirect("login")

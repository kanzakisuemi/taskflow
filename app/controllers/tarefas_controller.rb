class TarefasController < ApplicationController
  before_action :set_projeto, only: %i[new create]
  before_action :set_tarefa, only: %i[show edit update destroy atualizar_status]
  before_action :set_usuarios, only: %i[new edit create update]

  # UC05
  def index
    @tarefas = Tarefa.includes(:projeto, :usuario).filtrar(params).order(:prazo)
    @projetos = Projeto.order(:nome)
    @usuarios = Usuario.order(:nome)
  end

  def show
  end

  def new
    @tarefa = @projeto.tarefas.build
  end

  def edit
  end

  def create
    @tarefa = @projeto.tarefas.build(tarefa_params)

    if @tarefa.save
      redirect_to @projeto, notice: "Tarefa criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @tarefa.update(tarefa_params)
      redirect_to @tarefa.projeto, notice: "Tarefa atualizada com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tarefa.destroy
    redirect_to @tarefa.projeto, notice: "Tarefa excluída com sucesso.", status: :see_other
  end

  # UC04: altera só o status, aceitando apenas valores do enum.
  def atualizar_status
    if Tarefa.statuses.key?(params[:status]) && @tarefa.update(status: params[:status])
      redirect_to @tarefa.projeto, notice: "Status da tarefa atualizado.", status: :see_other
    else
      redirect_to @tarefa.projeto, alert: "Status inválido.", status: :see_other
    end
  end

  private

  def set_projeto
    @projeto = Projeto.find(params[:projeto_id])
  end

  def set_tarefa
    @tarefa = Tarefa.find(params[:id])
  end

  def set_usuarios
    @usuarios = Usuario.order(:nome)
  end

  # Status fica de fora: nasce pendente (RN04) e muda só via atualizar_status (UC04).
  def tarefa_params
    params.require(:tarefa).permit(:titulo, :descricao, :prioridade, :prazo, :usuario_id)
  end
end

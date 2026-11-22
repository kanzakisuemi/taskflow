class ProjetosController < ApplicationController
  before_action :set_projeto, only: %i[show edit update destroy]
  before_action :set_usuarios, only: %i[new edit create update]

  def index
    @projetos = Projeto.includes(:usuario).order(:nome)
  end

  def show
    @tarefas = @projeto.tarefas.includes(:usuario).order(:prazo)
  end

  def new
    @projeto = Projeto.new
  end

  def edit
  end

  def create
    @projeto = Projeto.new(projeto_params)

    if @projeto.save
      redirect_to @projeto, notice: "Projeto criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @projeto.update(projeto_params)
      redirect_to @projeto, notice: "Projeto atualizado com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @projeto.destroy
    redirect_to projetos_url, notice: "Projeto e suas tarefas excluídos com sucesso.", status: :see_other
  end

  private

  def set_projeto
    @projeto = Projeto.find(params[:id])
  end

  def set_usuarios
    @usuarios = Usuario.order(:nome)
  end

  def projeto_params
    params.require(:projeto).permit(:nome, :descricao, :status, :data_inicio, :data_fim_prevista, :usuario_id)
  end
end

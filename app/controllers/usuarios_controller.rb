class UsuariosController < ApplicationController
  before_action :set_usuario, only: %i[show edit update destroy]

  def index
    @usuarios = Usuario.order(:nome)
  end

  def show
  end

  def new
    @usuario = Usuario.new
  end

  def edit
  end

  def create
    @usuario = Usuario.new(usuario_params)

    if @usuario.save
      redirect_to @usuario, notice: "Usuário criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @usuario.update(usuario_params)
      redirect_to @usuario, notice: "Usuário atualizado com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # RN06: restrict_with_error impede a exclusão de quem tem projetos.
  def destroy
    if @usuario.destroy
      redirect_to usuarios_url, notice: "Usuário excluído com sucesso.", status: :see_other
    else
      redirect_to @usuario, alert: @usuario.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def set_usuario
    @usuario = Usuario.find(params[:id])
  end

  def usuario_params
    params.require(:usuario).permit(:nome, :email)
  end
end

require "test_helper"

class UsuarioTest < ActiveSupport::TestCase
  test "exige nome" do
    usuario = Usuario.new(email: "x@exemplo.com")
    assert_not usuario.valid?
    assert_includes usuario.errors[:nome], "não pode ficar em branco"
  end

  test "exige e-mail" do
    assert_includes Usuario.new(nome: "X").tap(&:valid?).errors[:email], "não pode ficar em branco"
  end

  test "rejeita e-mail inválido" do
    assert_not Usuario.new(nome: "X", email: "sem-arroba").valid?
  end

  test "rejeita e-mail repetido sem diferenciar maiúsculas" do
    assert_not Usuario.new(nome: "Outra Ana", email: "ANA@exemplo.com").valid?
  end

  test "não exclui usuário com projetos" do
    usuario = usuarios(:ana)
    assert_not usuario.destroy
    assert usuario.errors[:base].any?
  end

  test "excluir usuário deixa suas tarefas sem responsável" do
    tarefa = tarefas(:layout)
    usuarios(:bruno).destroy!
    assert_nil tarefa.reload.usuario
  end
end

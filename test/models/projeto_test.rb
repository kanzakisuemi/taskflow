require "test_helper"

class ProjetoTest < ActiveSupport::TestCase
  test "exige nome e responsável" do
    projeto = Projeto.new
    assert_not projeto.valid?
    assert projeto.errors[:nome].any?
    assert projeto.errors[:usuario].any?
  end

  test "status inicial é ativo" do
    assert Projeto.new.ativo?
  end

  test "término previsto não pode ser anterior ao início" do
    projeto = projetos(:site)
    projeto.assign_attributes(data_inicio: Date.new(2026, 5, 10), data_fim_prevista: Date.new(2026, 5, 9))
    assert_not projeto.valid?
    assert_includes projeto.errors[:data_fim_prevista], "não pode ser anterior à data de início"
  end

  test "aceita término igual ao início ou datas em branco" do
    projeto = projetos(:site)
    projeto.assign_attributes(data_inicio: Date.new(2026, 5, 10), data_fim_prevista: Date.new(2026, 5, 10))
    assert projeto.valid?
    projeto.data_inicio = nil
    assert projeto.valid?
  end

  test "percentual concluído é 0 sem tarefas" do
    assert_equal 0, projetos(:vazio).percentual_concluido
  end

  test "percentual concluído parcial" do
    assert_equal 50, projetos(:site).percentual_concluido
  end

  test "percentual concluído 100" do
    tarefas(:textos).concluida!
    assert_equal 100, projetos(:site).percentual_concluido
  end

  test "excluir projeto exclui suas tarefas" do
    assert_difference("Tarefa.count", -2) { projetos(:site).destroy }
  end
end

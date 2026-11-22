require "test_helper"

class TarefaTest < ActiveSupport::TestCase
  test "exige título e projeto" do
    tarefa = Tarefa.new
    assert_not tarefa.valid?
    assert tarefa.errors[:titulo].any?
    assert tarefa.errors[:projeto].any?
  end

  test "nasce pendente, com prioridade média e sem responsável obrigatório" do
    tarefa = projetos(:site).tarefas.create!(titulo: "Nova")
    assert tarefa.pendente?
    assert tarefa.media?
    assert_nil tarefa.usuario
  end

  test "atrasada quando o prazo passou e não está concluída" do
    assert Tarefa.new(prazo: Date.yesterday).atrasada?
  end

  test "não atrasada quando concluída, sem prazo ou com prazo hoje" do
    assert_not Tarefa.new(prazo: Date.yesterday, status: :concluida).atrasada?
    assert_not Tarefa.new.atrasada?
    assert_not Tarefa.new(prazo: Date.current).atrasada?
  end

  test "scope atrasadas" do
    tarefas(:textos).update!(prazo: Date.yesterday)
    tarefas(:layout).update!(prazo: Date.yesterday)
    assert_equal [tarefas(:textos)], Tarefa.atrasadas.to_a
  end

  test "filtrar ignora filtros em branco" do
    assert_equal Tarefa.count, Tarefa.filtrar(status: "", prioridade: nil).count
  end

  test "filtrar por status, prioridade, projeto e responsável" do
    assert_equal [tarefas(:textos)], Tarefa.filtrar(status: "pendente").to_a
    assert_equal [tarefas(:layout)], Tarefa.filtrar(prioridade: "alta").to_a
    assert_equal [tarefas(:layout)], Tarefa.filtrar(usuario_id: usuarios(:bruno).id).to_a
    assert_empty Tarefa.filtrar(projeto_id: projetos(:vazio).id)
  end
end

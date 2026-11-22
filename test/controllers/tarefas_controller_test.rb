require "test_helper"

class TarefasControllerTest < ActionDispatch::IntegrationTest
  test "cria tarefa pendente no projeto" do
    assert_difference("Tarefa.count") do
      post projeto_tarefas_url(projetos(:site)), params: { tarefa: { titulo: "Nova", prioridade: "alta", status: "concluida" } }
    end
    assert_redirected_to projeto_url(projetos(:site))
    assert Tarefa.last.pendente?
  end

  test "mostra erros ao criar tarefa sem título" do
    post projeto_tarefas_url(projetos(:site)), params: { tarefa: { titulo: "" } }
    assert_response :unprocessable_entity
    assert_match "Título não pode ficar em branco", response.body
  end

  test "mostra e abre formulários" do
    get tarefa_url(tarefas(:layout))
    assert_response :success
    get new_projeto_tarefa_url(projetos(:site))
    assert_response :success
    get edit_tarefa_url(tarefas(:layout))
    assert_response :success
  end

  test "atualiza tarefa" do
    patch tarefa_url(tarefas(:textos)), params: { tarefa: { titulo: "Textos finais" } }
    assert_redirected_to projeto_url(projetos(:site))
    assert_equal "Textos finais", tarefas(:textos).reload.titulo
  end

  test "exclui tarefa" do
    assert_difference("Tarefa.count", -1) { delete tarefa_url(tarefas(:textos)) }
    assert_redirected_to projeto_url(projetos(:site))
  end

  test "atualiza status" do
    patch atualizar_status_tarefa_url(tarefas(:textos)), params: { status: "em_andamento" }
    assert_redirected_to projeto_url(projetos(:site))
    assert tarefas(:textos).reload.em_andamento?
  end

  test "rejeita status inválido" do
    patch atualizar_status_tarefa_url(tarefas(:textos)), params: { status: "cancelada" }
    assert_redirected_to projeto_url(projetos(:site))
    assert_equal "Status inválido.", flash[:alert]
    assert tarefas(:textos).reload.pendente?
  end

  test "filtra tarefas" do
    get tarefas_url, params: { status: "pendente", projeto_id: projetos(:site).id }
    assert_response :success
    assert_select "td a", tarefas(:textos).titulo
    assert_select "td a", text: tarefas(:layout).titulo, count: 0
  end

  test "destaca tarefa atrasada" do
    tarefas(:textos).update!(prazo: Date.yesterday)
    get tarefas_url
    assert_select "tr.atrasada", 1
  end
end

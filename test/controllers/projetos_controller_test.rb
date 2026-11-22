require "test_helper"

class ProjetosControllerTest < ActionDispatch::IntegrationTest
  test "lista projetos com percentual" do
    get projetos_url
    assert_response :success
    assert_select ".progresso", text: /50%/
  end

  test "mostra projeto com suas tarefas" do
    get projeto_url(projetos(:site))
    assert_response :success
    assert_match tarefas(:layout).titulo, response.body
    assert_select "a", "Nova tarefa"
  end

  test "abre formulários" do
    get new_projeto_url
    assert_response :success
    get edit_projeto_url(projetos(:site))
    assert_response :success
  end

  test "cria projeto" do
    assert_difference("Projeto.count") do
      post projetos_url, params: { projeto: { nome: "Novo", usuario_id: usuarios(:bruno).id, status: "ativo" } }
    end
    assert_redirected_to projeto_url(Projeto.last)
  end

  test "mostra erros ao criar projeto inválido" do
    post projetos_url, params: { projeto: { nome: "", data_inicio: "2026-05-10", data_fim_prevista: "2026-05-01" } }
    assert_response :unprocessable_entity
    assert_match "não pode ser anterior à data de início", response.body
  end

  test "atualiza projeto" do
    patch projeto_url(projetos(:site)), params: { projeto: { status: "concluido" } }
    assert_redirected_to projeto_url(projetos(:site))
    assert projetos(:site).reload.concluido?
  end

  test "exclui projeto e suas tarefas" do
    assert_difference("Projeto.count" => -1, "Tarefa.count" => -2) { delete projeto_url(projetos(:site)) }
    assert_redirected_to projetos_url
  end
end

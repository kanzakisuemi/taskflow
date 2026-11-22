require "test_helper"

class UsuariosControllerTest < ActionDispatch::IntegrationTest
  test "lista, mostra e abre formulários" do
    get usuarios_url
    assert_response :success
    get usuario_url(usuarios(:ana))
    assert_response :success
    get new_usuario_url
    assert_response :success
    get edit_usuario_url(usuarios(:ana))
    assert_response :success
  end

  test "cria usuário" do
    assert_difference("Usuario.count") do
      post usuarios_url, params: { usuario: { nome: "Carla", email: "carla@exemplo.com" } }
    end
    assert_redirected_to usuario_url(Usuario.last)
  end

  test "mostra erros ao criar usuário inválido" do
    post usuarios_url, params: { usuario: { nome: "", email: "invalido" } }
    assert_response :unprocessable_entity
    assert_match "Nome não pode ficar em branco", response.body
  end

  test "atualiza usuário" do
    patch usuario_url(usuarios(:ana)), params: { usuario: { nome: "Ana Maria" } }
    assert_redirected_to usuario_url(usuarios(:ana))
    assert_equal "Ana Maria", usuarios(:ana).reload.nome
  end

  test "exclui usuário sem projetos" do
    assert_difference("Usuario.count", -1) { delete usuario_url(usuarios(:bruno)) }
    assert_redirected_to usuarios_url
  end

  test "bloqueia exclusão de usuário com projetos" do
    assert_no_difference("Usuario.count") { delete usuario_url(usuarios(:ana)) }
    assert_redirected_to usuario_url(usuarios(:ana))
    follow_redirect!
    assert_select ".alert", /projetos/
  end
end

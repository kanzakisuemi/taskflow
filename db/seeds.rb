# Idempotente: pode rodar mais de uma vez sem duplicar registros.
hoje = Date.current

ana = Usuario.find_or_create_by!(email: "ana@taskflow.dev") { |u| u.nome = "Ana Souza" }
bruno = Usuario.find_or_create_by!(email: "bruno@taskflow.dev") { |u| u.nome = "Bruno Lima" }
carla = Usuario.find_or_create_by!(email: "carla@taskflow.dev") { |u| u.nome = "Carla Mendes" }

projetos = {
  "Site institucional" => { usuario: ana, descricao: "Novo site da empresa.", data_inicio: hoje - 30, data_fim_prevista: hoje + 30 },
  "App de vendas" => { usuario: bruno, descricao: "Aplicativo para a equipe comercial.", data_inicio: hoje - 10, data_fim_prevista: hoje + 60 },
  "Migração de servidores" => { usuario: carla, descricao: "Levar os serviços para a nuvem.", data_inicio: hoje - 60, data_fim_prevista: hoje - 5, status: :concluido }
}.to_h do |nome, atributos|
  [nome, Projeto.find_or_create_by!(nome: nome) { |p| p.assign_attributes(atributos) }]
end

[
  ["Site institucional", "Definir layout", :concluida, :alta, hoje - 20, ana],
  ["Site institucional", "Escrever textos", :em_andamento, :media, hoje - 2, bruno],
  ["Site institucional", "Configurar domínio", :pendente, :baixa, hoje + 10, nil],
  ["Site institucional", "Publicar versão beta", :pendente, :alta, hoje + 25, ana],
  ["App de vendas", "Levantar requisitos", :concluida, :alta, hoje - 5, bruno],
  ["App de vendas", "Prototipar telas", :em_andamento, :media, hoje + 7, carla],
  ["App de vendas", "Integrar com o ERP", :pendente, :alta, hoje - 1, nil],
  ["App de vendas", "Testes com usuários", :pendente, :media, hoje + 40, bruno],
  ["Migração de servidores", "Inventariar serviços", :concluida, :media, hoje - 50, carla],
  ["Migração de servidores", "Migrar banco de dados", :concluida, :alta, hoje - 20, carla],
  ["Migração de servidores", "Desligar servidores antigos", :concluida, :baixa, hoje - 6, nil],
  ["Migração de servidores", "Documentar a nova infraestrutura", :pendente, :baixa, hoje - 3, ana]
].each do |projeto, titulo, status, prioridade, prazo, usuario|
  projetos.fetch(projeto).tarefas.find_or_create_by!(titulo: titulo) do |t|
    t.assign_attributes(status: status, prioridade: prioridade, prazo: prazo, usuario: usuario)
  end
end

puts "Seeds: #{Usuario.count} usuários, #{Projeto.count} projetos, #{Tarefa.count} tarefas."

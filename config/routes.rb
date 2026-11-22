Rails.application.routes.draw do
  root "projetos#index"

  resources :usuarios
  resources :projetos do
    resources :tarefas, except: :index, shallow: true do
      member { patch :atualizar_status }
    end
  end
  resources :tarefas, only: :index # UC05: listagem global com filtros
end

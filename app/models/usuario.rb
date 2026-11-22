class Usuario < ApplicationRecord
  # RN06: usuário com projetos não pode ser excluído.
  has_many :projetos, dependent: :restrict_with_error
  # RN05: ao excluir o usuário, suas tarefas ficam sem responsável.
  has_many :tarefas, dependent: :nullify

  # RN01: e-mail obrigatório, válido e único.
  validates :nome, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  def to_s = nome
end

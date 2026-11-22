class Projeto < ApplicationRecord
  belongs_to :usuario
  # RN10: excluir o projeto exclui suas tarefas.
  has_many :tarefas, dependent: :destroy

  enum :status, { ativo: 0, concluido: 1, arquivado: 2 }, default: :ativo

  # RN02: nome e responsável obrigatórios (o belongs_to já exige o usuário).
  validates :nome, presence: true
  validate :data_fim_nao_anterior_ao_inicio

  # RN08: concluídas ÷ total × 100, ou 0 sem tarefas.
  def percentual_concluido
    total = tarefas.count
    return 0 if total.zero?

    (tarefas.concluida.count * 100.0 / total).round
  end

  def to_s = nome

  private

  # RN03
  def data_fim_nao_anterior_ao_inicio
    return if data_inicio.blank? || data_fim_prevista.blank?

    errors.add(:data_fim_prevista, "não pode ser anterior à data de início") if data_fim_prevista < data_inicio
  end
end

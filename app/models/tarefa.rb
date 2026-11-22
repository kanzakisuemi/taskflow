class Tarefa < ApplicationRecord
  belongs_to :projeto
  belongs_to :usuario, optional: true

  # RN04: status inicial pendente.
  enum :status, { pendente: 0, em_andamento: 1, concluida: 2 }, default: :pendente
  enum :prioridade, { baixa: 0, media: 1, alta: 2 }, default: :media

  validates :titulo, presence: true

  # RN07: prazo vencido e não concluída.
  scope :atrasadas, -> { where("prazo < ?", Date.current).where.not(status: :concluida) }

  def atrasada? = prazo.present? && prazo < Date.current && !concluida?

  # UC05. Ignora filtros em branco.
  def self.filtrar(params)
    rel = all
    rel = rel.where(status: params[:status]) if params[:status].present?
    rel = rel.where(prioridade: params[:prioridade]) if params[:prioridade].present?
    rel = rel.where(projeto_id: params[:projeto_id]) if params[:projeto_id].present?
    rel = rel.where(usuario_id: params[:usuario_id]) if params[:usuario_id].present?
    rel
  end
end

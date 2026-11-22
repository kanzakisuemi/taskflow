class CreateTarefas < ActiveRecord::Migration[7.0]
  def change
    create_table :tarefas do |t|
      t.string :titulo, null: false
      t.text :descricao
      t.integer :status, null: false, default: 0
      t.integer :prioridade, null: false, default: 1
      t.date :prazo
      t.references :projeto, null: false, foreign_key: true
      t.references :usuario, null: true, foreign_key: true

      t.timestamps
    end
  end
end

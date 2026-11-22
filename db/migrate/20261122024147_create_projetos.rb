class CreateProjetos < ActiveRecord::Migration[7.0]
  def change
    create_table :projetos do |t|
      t.string :nome, null: false
      t.text :descricao
      t.integer :status, null: false, default: 0
      t.date :data_inicio
      t.date :data_fim_prevista
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end

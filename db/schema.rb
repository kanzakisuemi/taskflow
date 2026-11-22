# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2026_11_22_024148) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projetos", force: :cascade do |t|
    t.string "nome", null: false
    t.text "descricao"
    t.integer "status", default: 0, null: false
    t.date "data_inicio"
    t.date "data_fim_prevista"
    t.bigint "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_projetos_on_usuario_id"
  end

  create_table "tarefas", force: :cascade do |t|
    t.string "titulo", null: false
    t.text "descricao"
    t.integer "status", default: 0, null: false
    t.integer "prioridade", default: 1, null: false
    t.date "prazo"
    t.bigint "projeto_id", null: false
    t.bigint "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["projeto_id"], name: "index_tarefas_on_projeto_id"
    t.index ["usuario_id"], name: "index_tarefas_on_usuario_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nome", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
  end

  add_foreign_key "projetos", "usuarios"
  add_foreign_key "tarefas", "projetos"
  add_foreign_key "tarefas", "usuarios"
end

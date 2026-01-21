require "rails_helper"

RSpec.describe "Main flows", type: :request do
  let(:password) { "password" }
  let(:user) { User.create!(email: "user@example.com", password: password) }

  before do
    post user_session_path, params: { user: { email: user.email, password: password } }
  end

  describe "Criando uma lista" do
    it "Cria uma lista para o usuário autenticado" do
      expect {
        post lists_path, params: { list: { title: "Trabalho" } }
      }.to change(user.lists, :count).by(1)

      expect(response).to redirect_to(lists_path)
      expect(user.lists.find_by(title: "Trabalho")).to be_present
    end
  end

  describe "Criando uma tarefa" do
    it "Cria uma tarefa na lista selecionada" do
      list = user.lists.create!(title: "Principal")

      expect {
        post list_tasks_path(list), params: { task: { title: "Comprar leite" } }
      }.to change(list.tasks, :count).by(1)

      expect(response).to redirect_to(lists_path)
      expect(list.tasks.find_by(title: "Comprar leite")).to be_present
    end
  end

  describe "Alternando o status de uma tarefa" do
    it "alterna o status de concluída na tarefa" do
      list = user.lists.create!(title: "Principal")
      task = list.tasks.create!(title: "Verificar", done: false)

      expect {
        patch toggle_list_task_path(list, task)
      }.to change { task.reload.done? }.from(false).to(true)

      expect(response).to redirect_to(lists_path)
    end
  end
end

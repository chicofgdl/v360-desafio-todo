class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_list
    before_action :set_task, only: %i[edit update destroy]

    def create
        @task = @list.tasks.build(task_params)
        if @task.save
            redirect_to lists_path, notice: "Tarefa criada com sucesso."
        else
            redirect_to lists_path, alert: "Erro ao criar a tarefa."
        end
    end

    def edit
    end

    def update
        if @task.update(task_params)
            redirect_to lists_path, notice: "Tarefa atualizada com sucesso."
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @task.destroy
        redirect_to lists_path, notice: "Tarefa excluída com sucesso."
    end

    private

    def set_list
        @list = current_user.lists.find(params[:list_id])
    end

    def set_task
        @task = @list.tasks.find(params[:id])
    end

    def task_params
        params.require(:task).permit(:title, :done)
    end
end

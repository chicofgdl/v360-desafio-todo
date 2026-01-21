class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_list, except: %i[toggle_favorite]
    before_action :set_task, only: %i[edit update destroy toggle]
    before_action :set_task_for_favorite, only: %i[toggle_favorite]

    def create
        @task = @list.tasks.build(task_params)
        if @task.save
            redirect_to lists_path, notice: "Tarefa criada com sucesso."
        else
            message = duplicate_error?(@task, :title) ? "Ja existe uma tarefa com esse titulo nesta lista." : "Erro ao criar a tarefa."

            respond_to do |format|
                format.turbo_stream do
                    render turbo_stream: toast_stream(message), status: :unprocessable_entity
                end
                format.html { redirect_to lists_path, alert: message }
                format.json { render json: { error: message }, status: :unprocessable_entity }
            end
        end
    end

    def edit
    end

    def update
        if @task.update(task_params)
            redirect_to lists_path, notice: "Tarefa atualizada com sucesso."
        else
            message = duplicate_error?(@task, :title) ? "Ja existe uma tarefa com esse titulo nesta lista." : "Erro ao atualizar a tarefa."

            respond_to do |format|
                format.turbo_stream do
                    render turbo_stream: toast_stream(message), status: :unprocessable_entity
                end
                format.html do
                    flash.now[:alert] = message
                    render :edit, status: :unprocessable_entity
                end
                format.json { render json: { error: message }, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @task.destroy
        redirect_to lists_path, notice: "Tarefa excluída com sucesso."
    end

    def toggle
        @task.update!(done: !@task.done?)

        respond_to do |format|
            format.turbo_stream
            format.html { redirect_to lists_path }
        end
    end

    def toggle_favorite
        @task.update!(favorite: !@task.favorite?)
        redirect_back fallback_location: lists_path
    end

    def reorder
        ordered_ids = Array(params.require(:ordered_ids))

        Task.transaction do
            ordered_ids.each_with_index do |id, index|
                @list.tasks.find(id).insert_at(index + 1)
            end
        end

        head :no_content
    end

    private

    def set_list
        @list = current_user.lists.find(params[:list_id])
    end

    def set_task
        @task = @list.tasks.find(params[:id])
    end

    def set_task_for_favorite
        @task = Task.joins(:list).where(lists: { user_id: current_user.id }).find(params[:id])
    end

    def task_params
        params.require(:task).permit(:title, :due_at, :favorite)
    end
end

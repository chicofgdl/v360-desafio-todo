class ListsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_list, only: %i[ show edit update destroy]

    def index
        load_lists
        @list = current_user.lists.build
        @task = Task.new
        build_task_summary
    end

    def show
    end

    def new
        @list = current_user.lists.build
    end

    def create
        @list = current_user.lists.build(list_params)

        if @list.save
            redirect_to lists_path, notice: "Lista criada com sucesso."
        else
            load_lists
            build_task_summary
            @task = Task.new
            flash.now[:alert] = "Erro ao criar a lista."
            render :index, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @list.update(list_params)
            redirect_to lists_path, notice: "Lista atualizada com sucesso."
        else
            flash.now[:alert] = "Erro ao atualizar a lista."
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @list.destroy
        redirect_to lists_path, notice: "Lista excluída com sucesso."
    end

    private

    def set_list
        @list = current_user.lists.find(params[:id])
    end

    def list_params
        params.require(:list).permit(:title)
    end

    def load_lists
        @lists = current_user.lists.includes(:tasks).order(created_at: :desc)
    end

    def build_task_summary
        tasks = @lists.flat_map(&:tasks)

        @task_summary = {
            total: tasks.size,
            pending: tasks.count { |task| !task.done? },
            done: tasks.count(&:done?)
        }
    end
end

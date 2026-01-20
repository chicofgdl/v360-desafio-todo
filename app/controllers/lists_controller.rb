class ListsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_list, only: %i[ show edit update destroy]

    def index
        load_lists
        set_selection
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
            set_selection
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

    def set_selection
        @q = params[:q].to_s.strip
        @filter = normalize_filter(params[:filter])
        @selected_list = @filter.present? ? nil : find_selected_list
        @search_mode = @q.present?
        build_display_lists
    end

    def normalize_filter(filter)
        return if filter.blank? || filter == "all"

        allowed = %w[today soon overdue favorites]
        allowed.include?(filter) ? filter : nil
    end

    def find_selected_list
        return if params[:list_id].blank?

        @lists.find { |list| list.id == params[:list_id].to_i }
    end

    def build_display_lists
        if @search_mode
            @results_lists = search_lists(@q)
            @display_lists = @results_lists
            @tasks_by_list_id = {}
            return
        end

        if @filter.present?
            @tasks_by_list_id = filtered_tasks_by_list(@filter)
            @display_lists = @lists.select { |list| @tasks_by_list_id[list.id].present? }
        elsif @selected_list
            @display_lists = [ @selected_list ]
            @tasks_by_list_id = {}
        else
            @display_lists = @lists
            @tasks_by_list_id = {}
        end
    end

    def filtered_tasks_by_list(filter)
        tasks = tasks_scope
        tasks =
            case filter
            when "today" then tasks.due_today
            when "soon" then tasks.due_soon
            when "overdue" then tasks.overdue
            when "favorites" then tasks.favorited
            else tasks
            end

        tasks.order(:position).group_by(&:list_id)
    end

    def search_lists(query)
        pattern = "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"

        current_user.lists
            .left_joins(:tasks)
            .where("lists.title LIKE ? OR tasks.title LIKE ?", pattern, pattern)
            .distinct
            .includes(:tasks)
            .order(created_at: :desc)
    end

    def tasks_scope
        Task.joins(:list).where(lists: { user_id: current_user.id })
    end

    def build_task_summary
        tasks = tasks_scope

        @task_summary = {
            total: tasks.count,
            today: tasks.due_today.count,
            soon: tasks.due_soon.count,
            overdue: tasks.overdue.count,
            favorites: tasks.favorited.count
        }
    end
end

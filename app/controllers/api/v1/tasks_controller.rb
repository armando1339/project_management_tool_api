module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_project
      before_action :set_task, only: [ :show, :update, :destroy, :assign_user, :unassign_user ]

      def index
        @tasks = @project.tasks.where(project_id: params[:project_id])
        authorize @tasks

        render :index
      end

      def show
        authorize @task

        render :show
      end

      def create
        @task = @project.tasks.new(task_params)
        authorize @task

        if @task.save
          render :show, status: :created
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @task

        if @task.update(task_params)
          render :show
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @task
        @task.destroy

        head :no_content
      end

      def assign_user
        authorize @task, :assign?

        user = User.find(params[:user_id])
        @task.assigned_user = user

        if @task.save
          render json: { message: "User assigned successfully" }, status: :ok
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def unassign_user
        authorize @task, :assign?

        if @task.assigned_user.present?
          @task.update(assigned_user: nil)

          render json: { message: "User unassigned successfully" }, status: :ok
        else
          render json: { error: "No user is assigned to this task" }, status: :unprocessable_entity
        end
      end

      private

      def set_project
        @project = Project.find(params[:project_id])
      end

      def set_task
        @task = @project.tasks.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:title, :description, :status)
      end
    end
  end
end

module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :set_project, only: [:show, :update, :destroy]

      def index
        @projects = Project.all

        render :index
      end

      def show
        authorize @project

        render :show
      end

      def create
        @project = Project.new(project_params)
        authorize @project

        if @project.save
          render :show, status: :created
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @project

        if @project.update(project_params)
          render :show
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @project
        @project.destroy

        head :no_content
      end

      private

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(:name, :description)
      end
    end
  end
end

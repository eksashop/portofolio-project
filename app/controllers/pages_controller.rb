require './app/models/project'

class PagesController < Eksa::Controller
  def index
    @page = (params['page'] || 1).to_i
    @page = 1 if @page < 1
    per_page = 6
    
    total_projects = Project.count
    @total_pages = (total_projects.to_f / per_page).ceil
    
    @projects = Project.all.order_by(created_at: :desc).skip((@page - 1) * per_page).limit(per_page)
    @nama = params['nama'] || "Developer"
    render :index
  end
  def show
    begin
      @project = Project.find(params['id'])
      @title = "#{@project.title} - Portofolio"
      render :project_detail
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to "/", notice: "Project tidak ditemukan"
    end
  end

end
module Eksa
  class CmsController < Eksa::Controller
    def index
      return unless require_auth
      @projects = Project.all.order_by(created_at: :desc)
      render_internal 'cms/index'
    end

    def new_project
      return unless require_auth
      render_internal 'cms/new'
    end

    def create_project
      return unless require_auth
      
      image_url = ""
      if request.params['image'] && request.params['image'][:tempfile]
        upload_result = Cloudinary::Uploader.upload(request.params['image'][:tempfile].path)
        image_url = upload_result['secure_url']
      elsif params['image_url'] && !params['image_url'].empty?
        image_url = params['image_url']
      end

      project = Project.new(
        title: params['title'],
        description: params['description'],
        github_url: params['github_url'],
        demo_url: params['demo_url'],
        image_url: image_url
      )

      if project.save
        redirect_to "/cms", notice: "Project berhasil ditambahkan."
      else
        redirect_to "/cms/new", notice: "Gagal menambahkan project."
      end
    end

    def edit_project
      return unless require_auth
      @project = Project.find(params['id'])
      
      if @project
        render_internal 'cms/edit'
      else
        redirect_to "/cms", notice: "Project tidak ditemukan."
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to "/cms", notice: "Project tidak ditemukan."
    end

    def update_project
      return unless require_auth
      @project = Project.find(params['id'])
      
      image_url = @project.image_url
      if request.params['image'] && request.params['image'][:tempfile]
        upload_result = Cloudinary::Uploader.upload(request.params['image'][:tempfile].path)
        image_url = upload_result['secure_url']
      elsif params['image_url'] && !params['image_url'].empty?
        image_url = params['image_url']
      end

      if @project.update(
        title: params['title'],
        description: params['description'],
        github_url: params['github_url'],
        demo_url: params['demo_url'],
        image_url: image_url
      )
        redirect_to "/cms", notice: "Project berhasil diperbarui."
      else
        redirect_to "/cms/edit/#{params['id']}", notice: "Gagal memperbarui project."
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to "/cms", notice: "Project tidak ditemukan."
    end

    def delete_project
      return unless require_auth
      @project = Project.find(params['id'])
      @project.destroy
      redirect_to "/cms", notice: "Project berhasil dihapus."
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to "/cms", notice: "Project tidak ditemukan."
    end
  end
end

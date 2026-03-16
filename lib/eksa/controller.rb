require 'erb'

module Eksa
  class Controller
    attr_reader :request
    attr_accessor :status, :redirect_url, :flash

    def initialize(request)
      @request = request
      @status = 200
      @flash = {}
    end

    def params
      @request.params
    end

    def session
      @request.session
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = session['user_id'] ? Eksa::User.find_user(session['user_id']) : nil
    end

    def require_auth
      unless current_user
        redirect_to "/auth/login", notice: "Anda harus login untuk mengakses halaman ini."
        return false
      end
      true
    end

    def stylesheet_tag(filename)
      "<link rel='stylesheet' href='/css/#{filename}.css'>"
    end

    def javascript_tag(filename)
      "<script src='/js/#{filename}.js'></script>"
    end

    def asset_path(path)
      path.start_with?('/') ? path : "/#{path}"
    end

    def redirect_to(url, notice: nil)
      @status = 302
      @redirect_url = url
      @flash[:notice] = notice if notice
      nil
    end

    def render(template_name, variables = {})
      variables.each { |k, v| instance_variable_set("@#{k}", v) }

      content_path = File.expand_path("./app/views/#{template_name}.html.erb")
      internal_content_path = File.expand_path("../../eksa/views/#{template_name}.html.erb", __FILE__)
      
      layout_path  = File.expand_path("./app/views/layout.html.erb")
      internal_layout_path  = File.expand_path("../../eksa/views/layout.html.erb", __FILE__)

      actual_content_path = File.exist?(content_path) ? content_path : internal_content_path
      actual_layout_path = File.exist?(layout_path) ? layout_path : internal_layout_path

      if File.exist?(actual_content_path)
        @content = ERB.new(File.read(actual_content_path)).result(binding)
        if File.exist?(actual_layout_path)
          ERB.new(File.read(actual_layout_path)).result(binding)
        else
          @content
        end
      else
        "<div class='glass' style='padding: 2rem; border-radius: 1rem; color: #ff5555; background: rgba(255,0,0,0.1); backdrop-filter: blur(10px);'>
          <h2 style='margin-top:0;'>⚠️ View Error</h2>
          <p>Template <strong>#{template_name}</strong> tidak ditemukan di app/views atau internal eksa/views.</p>
        </div>"
      end
    end

    def render_internal(template_name, variables = {})
      render(template_name, variables)
    end
  end
end
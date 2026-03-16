class SeoController < Eksa::Controller
  def robots
    scheme = request.env['rack.url_scheme'] || 'https'
    content = <<~TEXT
      User-agent: *
      Allow: /
      Disallow: /cms
      Disallow: /auth
      
      Sitemap: #{scheme}://#{request.host}/sitemap.xml
    TEXT
    [200, { "Content-Type" => "text/plain" }, [content]]
  end

  def sitemap
    scheme = request.env['rack.url_scheme'] || 'https'
    base_url = "#{scheme}://#{request.host}"
    lastmod = Time.now.strftime("%Y-%m-%d")
    
    xml = '<?xml version="1.0" encoding="UTF-8"?>'
    xml += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
    
    # Base Page (Homepage)
    xml += "<url>"
    xml += "<loc>#{base_url}/</loc>"
    xml += "<lastmod>#{lastmod}</lastmod>"
    xml += "<priority>1.0</priority>"
    xml += "</url>"

    # Projects
    Project.all.each do |project|
      xml += "<url>"
      xml += "<loc>#{base_url}/project/#{project.id.to_s}</loc>"
      xml += "<lastmod>#{project.created_at ? project.created_at.strftime("%Y-%m-%d") : lastmod}</lastmod>"
      xml += "<priority>0.8</priority>"
      xml += "</url>"
    end
    
    xml += '</urlset>'
    [200, { "Content-Type" => "application/xml" }, [xml]]
  end
end

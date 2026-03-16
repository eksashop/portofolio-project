require 'dotenv/load'
require 'mongoid'
require 'cloudinary'

Mongoid.load!(File.expand_path("config/mongoid.yml", __dir__), ENV['RACK_ENV'] || :development)

Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
  config.api_key    = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
  config.secure = true
end

require './lib/eksa'

Dir[File.join(__dir__, 'app/models/*.rb')].each { |file| require_relative file }
Dir[File.join(__dir__, 'app/controllers/*.rb')].each { |file| require_relative file }

app = Eksa::Application.new do |config|
  config.use Rack::Static, urls: ["/css", "/img", "/uploads"], root: "public"
  config.use Rack::ShowExceptions
end

app.add_route "/", PagesController, :index
app.add_route "/project/:id", PagesController, :show
app.add_route "/robots.txt", SeoController, :robots
app.add_route "/sitemap.xml", SeoController, :sitemap

run app
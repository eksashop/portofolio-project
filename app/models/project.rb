class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,       type: String
  field :description, type: String
  field :github_url,  type: String
  field :demo_url,    type: String
  field :image_url,   type: String

  validates_presence_of :title, :description, :github_url
end

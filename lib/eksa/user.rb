module Eksa
  class User
    include Mongoid::Document
    include Mongoid::Timestamps

    field :username, type: String
    field :password_hash, type: String

    index({ username: 1 }, { unique: true })

    require 'bcrypt'

    def self.create_user(username, password)
      hash = BCrypt::Password.create(password)
      create(username: username, password_hash: hash)
    end

    def self.update_password(username, new_password)
      hash = BCrypt::Password.create(new_password)
      user = where(username: username).first
      user.update(password_hash: hash) if user
    end

    def self.authenticate(username, password)
      user = where(username: username).first
      return nil unless user

      stored_hash = BCrypt::Password.new(user.password_hash)
      if stored_hash == password
        { id: user.id.to_s, username: user.username }
      else
        nil
      end
    end

    # Keep compatibility with original SQLite User model
    def self.find_user(id)
      begin
        user = find(id)
        user ? { id: user.id.to_s, username: user.username } : nil
      rescue Mongoid::Errors::DocumentNotFound
        nil
      end
    end
  end
end

class User < ActiveRecord::Base
  has_many :favorite_names # just the 'relationships'
  has_many :favorites, through: :favorite_names, source: :name # the actual names a user favorites


  def self.find_or_create_from_omniauth(auth_hash)
    user = self.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])
    if !user.nil?
      binding.pry
      user.update(oauth_token: "#{auth_hash["credentials"]["token"]}")
      user.update(oauth_expires_at: Time.at(auth_hash["credentials"]["expires_at"]))
      return user
    else
      user = User.new
      user.uid = auth_hash["uid"]
      user.provider = auth_hash["provider"]
      user.name = auth_hash["info"]["name"]
      user.picture = auth_hash["info"]["image"]
      user.oauth_token = auth_hash["credentials"]["token"]
      user.oauth_expires_at = Time.at(auth_hash["credentials"]["expires_at"])
      if user.save
        return user
      else
        return nil
      end
    end
  end


end

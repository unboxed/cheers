class User < ActiveRecord::Base
  def self.find_or_create_by_name(name)
    user = find_by_name(name) || User.create(name: name)
  end
end

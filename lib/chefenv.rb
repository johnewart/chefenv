require 'chefenv/cli'

class ChefEnv
  def self.chef_dir
    "#{ENV['HOME']}/.chef" 
  end

  def self.chefenv_dir 
    "#{ENV['HOME']}/.chefenv"
  end


end

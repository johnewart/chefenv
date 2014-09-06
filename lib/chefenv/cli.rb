require 'thor'
require 'erb'
require 'chefenv'
require 'chefenv/profile'
require 'fileutils'

class ChefEnv
  class Cli < Thor
    desc "init", "initialize chefenv for use"
    def init
      puts "Initializing chefenv in #{ChefEnv::chefenv_dir}"
      if Dir.exists?(ChefEnv::chef_dir)
        puts "Chef directory exists, checking if we need to move things around"
        if File.exists?("#{ChefEnv::chef_dir}/knife.rb")
          # Check to see if it's us...
          kniferb_file = "#{ChefEnv::chef_dir}/knife.rb"
          kniferb = File.read(kniferb_file)
          if kniferb !~ /^# Managed by ChefEnv.*$/m
            puts "Moving existing files out of the way into #{ChefEnv::chefenv_dir}/default"
            FileUtils.mkdir_p "#{ChefEnv::chefenv_dir}/default"
            FileUtils.mv Dir.glob("#{ChefEnv::chef_dir}/*"), "#{ChefEnv::chefenv_dir}/default"
            setup_kniferb
          else
            puts "Already managed by ChefEnv, nothing to do!"
          end
        else
          # No knife.rb
          setup_kniferb
        end
      end
    end

    desc "create NAME", "create a profile called NAME"
    def create(name)
      puts "Creating... #{name}"
      p = Profile.new({:name => name})
      p.chef_server_url = ask "Chef server URL: "
      p.node_name = ask "Node name: "
      p.save

      puts "Certificate data - file paths or raw PEM data is acceptable. Files will be copied."
      user_pem = ask "User PEM file path or data: "
      validator_pem = ask "Validation key file path or data: "

      user_pem_dest ="#{p.profile_dir}/user.pem" 
      validator_pem_dest = "#{p.profile_dir}/validator.pem"

      if user_pem =~ /PRIVATE KEY/
        puts "Writing PEM to #{user_pem_dest}"
        File.open(user_pem_dest) { |f| f.write(user_pem) }
      else 
        puts "Copying #{user_pem} to #{user_pem_dest}"
        FileUtils.cp user_pem, user_pem_dest
      end

      if validator_pem =~ /PRIVATE KEY/
        puts "Writing PEM to #{validator_pem_dest}"
        File.open(validator_pem_dest) { |f| f.write(validator_pem) }
      else
        puts "Copying #{validator_pem} to #{validator_pem_dest}"
        FileUtils.cp validator_pem, validator_pem_dest
      end
    end

    desc 'profiles', 'list all profiles'
    def profiles
      profiles = Profile.list
      active_env = ENV['CHEF_ENV'] || 'default'
      profiles.each do |p|
        if p == active_env
          print " *"
        else 
          print "  "
        end
        puts p
      end
    end

    desc 'show NAME', 'show the profile called NAME'
    def show(name)
      profile = Profile.load(name)
      puts profile.inspect
    end

    private
    def setup_kniferb
      kniferb_file = "#{ChefEnv::chef_dir}/knife.rb"
      puts "Writing ChefEnv knife.rb"
      template_file = File.expand_path("../templates/knife.rb.erb", File.dirname(__FILE__)) 
      #template = File.read(template_file)
      #erb = ERB.new(template, 0, ">")
      #File.open(kniferb_file, "w") { |f| f.write erb.result(binding)
      new_kniferb = File.read(template_file)
      File.open(kniferb_file, "w") { |f| f.write(new_kniferb) }
    end
  end
end

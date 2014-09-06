require 'yaml'
require 'fileutils'

class ChefEnv
  class Profile
    attr_accessor :name,
                  :chef_server_url,
                  :log_level,
                  :log_location,
                  :node_name,
                  :validator,
                  :ssl_verify_mode,
                  :path,
                  :aws,
                  :rackspace

    def initialize(opts = {})
      @name ||= opts[:name]
    end

    def save 
      yaml = YAML::dump(self.to_hash)

      FileUtils.mkdir_p base_dir
      %w(cookbooks site_cookbooks checksums).each do |subdir|
        FileUtils.mkdir_p "#{base_dir}/#{subdir}"
      end

      open(yaml_file, 'w') do |f|
        f.write yaml
      end
    end

    def self.load(name)
      data_file = "#{profile_dir name}/config.yml"
      YAML.load_file(data_file)
    end

    def self.list
      Dir.glob("#{ChefEnv::chefenv_dir}/*").select { |p| 
        File.directory? p
      }.each { |dir|
        dir.gsub! "#{ChefEnv::chefenv_dir}/", ""
      }
    end

    def to_hash
      hash = {}
      (self.instance_variables).each do |var|
        varname = var.to_s.gsub("@", "")
        hash[varname] = self.instance_variable_get var
      end
      hash
    end

    def profile_dir
      Profile.profile_dir @name
    end

    private
    def self.profile_dir name
      "#{ChefEnv::chefenv_dir}/#{name}"
    end

    def base_dir
      Profile.profile_dir @name
    end

    def yaml_file
      "#{base_dir}/config.yml" 
    end

    
  end
end

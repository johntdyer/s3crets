class Configuratron

    attr_reader :keys, :overwrite, :files_updated

    def initialize(opts={})
        if opts[:secrets_file]
            begin
                @secrets = YAML::load_file(opts[:secrets_file])
            rescue Exception => e
                raise RuntimeError, "Yaml config file not found"
            end
        else
            @secrets = find_secrets
        end

        @files_updated = []

        @overwrite = opts.has_key?(:overwrite) ? opts[:overwrite] : false

        replace_config(opts[:json_dir])

    end

    def replace_config(dir)
        counter = 0
        search_folder  =  File.expand_path(dir)
        files          =  Dir.glob(search_folder + "/*.json")

        if files.empty?
            puts "Was unable to find any JSON files [#{search_folder}]"
        else

            Dir.glob(File.expand_path(dir) + "/*.json") do |json_file|

                next if json_file =~ /.new./

                begin
                    node_data  =  JSON.parse(File.read(json_file)+".")
                rescue JSON::ParserError => e
                    raise RuntimeError, "JSON Parse error -> #{json_file}"
                end

                # See if keys have intersection
                unless (@secrets.keys & node_data.keys).empty?
                    node_data.merge! @secrets.select { |k| node_data.keys.include? k }
                    file_to_write = get_file_name(json_file)
                    write_file(file_to_write,node_data)
                end
            end
        end
    end

    private

    def write_file(file,data)
        @files_updated << file
        File.open(file, 'w') do |fh|
            fh.puts JSON.pretty_generate(data)
            fh.close
        end
    end

    def get_file_name(json_file)
        f = File.split(json_file)
        path = f[0]
        file = f[1]

        if @overwrite
            json_file
        else
            File.join(path , file.insert(file.index("."),".new"))
        end
    end

    #Climb path looking for .secrets file
    def find_secrets
        secrets = nil
        Pathname.new(Dir.pwd).ascend{ |dir|
            config_file = dir + ".secrets"
            secrets =  YAML::load_file(config_file) if dir.children.include?(config_file)
        }

        if secrets.nil? or secrets.kind_of?(FalseClass)
            raise RuntimeError, "[FATAL] - Unable to find or parse secrets file, giving up"
        else
            return secrets
        end
    end

end

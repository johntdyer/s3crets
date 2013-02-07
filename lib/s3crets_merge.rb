class Configuratron

    attr_reader :keys, :overwrite

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

        replace_config(opts[:json_dir])

        @overwrite = opts.has_key?(:overwrite) ? opts[:overwrite] : false
    end

    def replace_config(dir)

        Dir.glob(dir + "/*.json") do |json_file|

            next if json_file =~ /.new./

            @secrets.keys.each do |k|
                node_data =  JSON.parse(File.read(json_file))

                if node_data.dig(k)

                    json = node_data.merge({
                                k => node_data[k].merge!(@secrets[k])
                            })
                    new_file = json_file.dup.insert(json_file.index("."),".new")

                    File.open(new_file, 'w') do |fh|
                       fh.puts JSON.pretty_generate(json)
                       fh.close
                    end
                end
            end
        end
    end

    private

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

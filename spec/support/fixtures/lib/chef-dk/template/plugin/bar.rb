module ChefDK
  module Template
    class Plugin
      class Bar
        class << self
          def description
            'bar cookbook template'
          end

          def code_generator_path(classfile)
            File.expand_path(
              File.join(
                classfile,
                '..', '..', '..', '..', '..',
                'code_generator_2'
              )
            )
          end
        end
      end
    end
  end
end

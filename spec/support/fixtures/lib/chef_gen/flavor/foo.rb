module ChefGen
  module Flavor
    class Foo
      NAME = 'foo'
      DESC = 'foo cookbook template'

      def initialize(temp_path:)
        @temp_path = temp_path
      end

      def add_content
        FileUtils.cp_r(
          File.expand_path(
            File.join(
              File.dirname(__FILE__),
              '..', '..', '..', 'shared', 'flavor', NAME
            )
          ) + '/.',
          @temp_path
        )
      end
    end
  end
end

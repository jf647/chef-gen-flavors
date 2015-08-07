module ChefGen
  module Flavor
    class Baz
      NAME = 'baz'
      DESC = 'baz cookbook template'

      def initialize(temp_path:)
        @temp_path = temp_path
      end

      def add_content
      end
    end
  end
end

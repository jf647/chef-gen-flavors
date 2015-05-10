# rubocop:disable Metrics/MethodLength
module ChefDK
  module Template
    module Mixin
      # populates the list of ignore patterns for chefignore and .gitignore
      module StandardIgnore
        # adds ignore patterns for chefignore
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_standardignore_chefignore(recipe)
          @chefignore_files << <<END.split("\n")
.DS_Store
Icon?
nohup.out
ehthumbs.db
Thumbs.db
.sass-cache
\#*
.#*
*~
*.sw[a-z]
*.bak
REVISION
TAGS*
tmtags
*_flymake.*
*_flymake
*.tmproj
.project
.settings
mkmf.log
a.out
*.o
*.pyc
*.so
*.com
*.class
*.dll
*.exe
*/rdoc/
.watchr
.rspec
spec/*
spec/fixtures/*
test/*
features/*
Guardfile
Procfile
.git
*/.git
.gitignore
.gitmodules
.gitconfig
.gitattributes
.svn
*/.bzr/*
*/.hg/*
*/.svn/*
Berksfile
Berksfile.lock
cookbooks/*
tmp
CONTRIBUTING
Colanderfile
Strainerfile
.colander
.strainer
.vagrant
Vagrantfile
.travis.yml
END
        end

        # adds ignore patterns for .gitignore
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_standardignore_gitignore(recipe)
          @gitignore_files << <<END.split("\n")
.vagrant
Berksfile.lock
*~
*#
.#*
\#*#
.*.sw[a-z]
*.un~
Gemfile.lock
bin/*
.bundle/*
.kitchen/
.kitchen.local.yml
END
        end
      end
    end
  end
end

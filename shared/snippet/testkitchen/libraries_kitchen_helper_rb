# produces ERB to conditionally set proxy vars in kitchen at
# runtime.  This can't go directly in the template because if
# it does it gets evaluated at generation time in the context
# of ChefDK
def kitchen_proxy_vars(indentspaces)
  <<END
<% %w(http_proxy https_proxy no_proxy).each do |envvar| %>
<% if ENV.key?(envvar) %>
#{' ' * indentspaces}<%= envvar %>: '<%= ENV[envvar] %>'
<% end %>
<% end %>
END
end

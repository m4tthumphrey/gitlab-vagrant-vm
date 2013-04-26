# Clone Gitlab Shell repo from github
git node['gitlab']['app_shell_home'] do
  repository node['gitlab']['gitlab_shell_url']
  reference node['gitlab']['gitlab_shell_branch']
  action :checkout
  user 'root'
end

# Render gitlab shell config file
template "#{node['gitlab']['app_shell_home']}/config.yml" do
  source "gitlab_shell.yml.erb"
  user node['gitlab']['host_user_id']
  group node['gitlab']['host_group_id']
  mode 0644
end

# GitLab Shell application install script
execute "gitlab-shell install" do
  command "su -l -c 'cd #{node['gitlab']['app_shell_home']} && ./bin/install' vagrant"
  cwd node['gitlab']['app_shell_home']
  user 'root'
end

# Symlink gitlab-shell to vagrant home, so that sidekiq can use gitlab shell commands
link "#{node['gitlab']['home']}/gitlab-shell" do
  to node['gitlab']['app_shell_home']
end
app = search("aws_opsworks_app").first
app_path = "/opt/#{app['shortname']}"

git app_path do
  repository app['app_source']['url']
  reference "master"
  action :sync
  notifies :run, 'execute[go-build]', :immediately
end

execute 'go-build' do
  command "go build -o /usr/local/bin/#{app['shortname']} ."
  cwd app_path
  action :nothing
end

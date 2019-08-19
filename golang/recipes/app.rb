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
  notifies :restart, "systemd_unit[#{app['shortname']}.service]", :delayed
end

systemd_unit "#{app['shortname']}.service" do
  content <<-EOF
    [Unit]
    Description=Test service

    [Service]
    TimeoutStartSec=0
    ExecStart=/usr/local/bin/#{app['shortname']}

    [Install]
    WantedBy=multi-user.target
  EOF
  .gsub(/^ +/, "")

  action [:create, :enable, :start]
  notifies :restart, "systemd_unit[#{app['shortname']}.service]", :delayed
end

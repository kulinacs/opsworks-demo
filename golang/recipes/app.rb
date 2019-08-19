app = search("aws_opsworks_app").first
Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")

git "/opt/app" do
  repository app['app_source']['url']
  reference "master"
  action :sync
end

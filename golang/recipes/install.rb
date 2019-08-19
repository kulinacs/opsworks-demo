apt_repository 'golang' do
  uri          'ppa:longsleep/golang-backports'
end

apt_package 'golang-go'

require "spec_helper"

case os[:family]
when "freebsd"
  describe file("/etc/resolvconf.conf") do
    its(:content) { should match(/# Managed by ansible$/) }
    its(:content) { should match(/^name_servers=".*"$/) }
  end
end
describe file("/etc/resolv.conf") do
  its(:content) { should match(/# Managed by ansible$/) }
  [1, 2, 3].each do |i|
    its(:content) { should match(/^nameserver 192\.168\.1\.#{i}$/) }
  end
  case os[:family]
  when "openbsd"
    its(:content) { should match(/^domain i\.trombik\.org$/) }
    its(:content) { should match(/^lookup file bind$/) }
  else
    its(:content) { should match(/^# beginning of resolver_config\n\n# end of resolver_config$/) }
  end
end

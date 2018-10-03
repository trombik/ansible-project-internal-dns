require "spec_helper"

case os[:family]
when "freebsd"
  describe file("/etc/resolvconf.conf") do
    case host_inventory["fqdn"]
    when "default-freebsd-103-amd64"
      its(:content) { should match(/name_servers="192\.168\.1\.2 192\.168\.1\.3 192\.168\.1\.1"/) }
    when "default-freebsd-111-amd64"
      its(:content) { should match(/name_servers="192\.168\.1\.1 192\.168\.1\.3 192\.168\.1\.2"/) }
    end
  end
end

describe file("/etc/resolv.conf") do
  its(:content) { should_not match(/nameserver\s+#{ Regexp.escape('10.0.2.3') }/) }
  case host_inventory["fqdn"]
  when "default-freebsd-103-amd64"
    its(:content) { should match(/nameserver 192\.168\.1\.2\nnameserver 192\.168\.1\.3\nnameserver 192\.168\.1\.1/) }
  when "default-openbsd-60-amd64"
    its(:content) { should match(/nameserver 192\.168\.1\.2\nnameserver 192\.168\.1\.1\nnameserver 192\.168\.1\.3/) }
  when "default-ubuntu-1404-amd64", "default-openbsd-62-amd64", "default-openbsd-61-amd64"
    its(:content) { should match(/nameserver 192\.168\.1\.3\nnameserver 192\.168\.1\.2\nnameserver 192\.168\.1\.1/) }
  when "default-centos-73-x86-64"
    its(:content) { should match(/nameserver 192\.168\.1\.3\nnameserver 192\.168\.1\.1\nnameserver 192\.168\.1\.2/) }
  when "default-freebsd-111-amd64"
    its(:content) { should match(/nameserver 192\.168\.1\.1\nnameserver 192\.168\.1\.3\nnameserver 192\.168\.1\.2/) }
  when "default-ubuntu-1604-amd64"
    its(:content) { should match(/nameserver 192\.168\.1\.1\nnameserver 192\.168\.1\.2\nnameserver 192\.168\.1\.3/) }
  else
    its(:content) { should match(/nameserver 192\.168\.1\.2\nnameserver 192\.168\.1\.3\nnameserver 192\.168\.1\.1/) }
  end
end
# 2 1 3

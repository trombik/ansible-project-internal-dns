require_relative "../spec_helper"

domain_name = case test_environment
              when "virtualbox"
                "i.trombik.org"
              end
domain_name_servers = case test_environment
                      when "virtualbox"
                        "172.16.100.254"
                      end
dhcp_flags = case test_environment
             when "virtualbox"
               "em1"
             end

subnets = case test_environment
          when "virtualbox"
            [
              {
                network: "172.16.100.0", netmask: "255.255.255.0", from: "172.16.100.100", to: "172.16.100.200",
                option: [
                  "broadcast-address 172.16.100.255",
                  "routers 172.16.100.254"
                ]
              }
            ]
            # TODO: test this
          else []
          end
dig_command = case os[:family]
              when "openbsd"
                "dig"
              when "freebsd"
                "drill"
              end
records = case test_environment
          when "virtualbox"
            [
              { q: "foo.i.trombik.org.", type: "A", a: "192.168.1.3" }
            ]
          when "prod"
            [
              { q: "pkg.i.trombik.org.", type: "CNAME", a: "t440s.i.trombik.org." }
            ]
          end

describe file "/etc/rc.conf.local" do
  it { should be_file }
  its(:content) { should match(/^dhcpd_flags=#{dhcp_flags}$/) }
end

describe file "/etc/dhcpd.conf" do
  it { should be_file }
  its(:content) { should match(/^option domain-name "#{domain_name}";$/) }
  its(:content) { should match(/option domain-name-servers #{domain_name_servers};$/) }
  its(:content) { should match(/^default-lease-time 86400;$/) }
  its(:content) { should match(/^max-lease-time 86400;$/) }
  subnets.each do |subnet|
    its(:content) { should match(/^subnet #{subnet[:network]} netmask #{subnet[:netmask]} {/) }
  end
end

describe command "#{dig_command} example.org @10.0.2.15" do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^;.*status: NOERROR/) }
end

describe command "date +%z" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^\+0700$/) }
end

describe file "/etc/resolv.conf" do
  it { should be_file }
  its(:content) { should match(/^domain #{domain_name}$/) }
end

records.each do |record|
  describe command "#{dig_command} #{record[:type]} #{record[:q]}" do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^;.*status: NOERROR/) }
    its(:stdout) { should match(/^#{record[:q]}\s+\d+\s+IN\s+#{record[:type]}\s+#{record[:a]}$/) }
  end
end

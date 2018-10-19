require_relative "../spec_helper"

case test_environment
when "virtualbox"
  context "after provision finishes" do
    all_hosts_in("virtualbox").each do |s|
      describe s do
        it "runs `echo foo`" do
          r = current_server.ssh_exec "echo foo"
          expect(r).to match(/^foo$/)
        end
      end
    end
    (all_hosts_in("ns") + all_hosts_in("client")).each do |s|
      describe s do
        let(:dig_command) do
          case current_server.ssh_exec "uname -s".chomp
          when /FreeBSD/
            "drill -t"
          when /OpenBSD/
            "dig"
          else
            raise "Unknown OS"
          end
        end

        it "has a list of internal DNS server in /etc/resolv.conf" do
          r = current_server.ssh_exec "cat /etc/resolv.conf"
          all_hosts_in("ns").each do |ns_server|
            expect(r).to match(/^nameserver\s+#{ns_server.server.address}$/)
          end
        end

        it "resolves internal-only A RRs" do
          yaml = YAML.load_file(playbooks_path + "group_vars" + "#{test_environment}.yml")
          expect(yaml["project_hosts"].length).not_to eq 0
          yaml["project_hosts"].each do |host|
            r = current_server.ssh_exec "#{dig_command} #{host['name']}.i.trombik.org"
            expect(r).to match(/^;; ANSWER SECTION:\n#{host['name']}\.i\.trombik\.org\.\s+86400\s+IN\s+A\s+#{host['ipv4']}$/)
          end
        end

        it "resolves external RR over TCP" do
          r = current_server.ssh_exec "#{dig_command} a example.org"
          expect(r).to match(/(rcode|status): NOERROR/)
        end
      end
    end
  end
end

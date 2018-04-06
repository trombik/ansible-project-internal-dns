require_relative "../spec_helper"

case test_environment
when "virtualbox"
  context "after provision finishes" do
    all_hosts_in("example").each do |s|
      describe s do
        it "runs `echo foo`" do
          r = current_server.ssh_exec "echo foo"
          expect(r).to match(/^foo$/)
        end
      end
    end
  end
end

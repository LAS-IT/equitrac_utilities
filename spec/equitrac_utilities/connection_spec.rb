require "spec_helper"

RSpec.describe EquitracUtilities::Connection do
  context "server paramters are correct" do
    it "shows correct host name from parameters" do
      stub_const('ENV', ENV.to_hash.merge('EQ_HOSTNAME' => 'eq_hostname'))
      eq = EquitracUtilities::Connection.new({hostname: 'params_host'})
      expect(eq.hostname).to eq('params_host')
    end
    it "shows correct host name from environment" do
      stub_const('ENV', ENV.to_hash.merge('EQ_HOSTNAME' => 'eq_hostname'))
      eq = EquitracUtilities::Connection.new
      expect(eq.hostname).to eq(ENV['EQ_HOSTNAME'])
    end
    it "shows correct user from parameters" do
      stub_const('ENV', ENV.to_hash.merge('EQ_USERNAME' => 'eq_username'))
      eq = EquitracUtilities::Connection.new({username: 'params_user'})
      expect(eq.username).to eq('params_user')
    end
    it "shows correct user from environment" do
      stub_const('ENV', ENV.to_hash.merge('EQ_USERNAME' => 'eq_username'))
      eq = EquitracUtilities::Connection.new
      expect(eq.username).to eq(ENV['EQ_USERNAME'])
    end
    it "shows correct service name from parameters" do
      stub_const('ENV', ENV.to_hash.merge('EQ_SERVICENAME' => 'eq_servicename'))
      eq = EquitracUtilities::Connection.new({servicename: 'params_service'})
      expect(eq.servicename).to eq('params_service')
    end
    it "shows correct service name from environment" do
      stub_const('ENV', ENV.to_hash.merge('EQ_SERVICENAME' => 'eq_servicename'))
      eq = EquitracUtilities::Connection.new
      expect(eq.servicename).to eq(ENV['EQ_SERVICENAME'])
    end
    it "shows correct default eqcmd path when no env var" do
      stub_const('ENV', ENV.to_hash.merge('EQ_EQCMD_PATH' => nil))
      eq = EquitracUtilities::Connection.new
      expect(eq.eqcmd_path).to eq('C:\Program Files\Equitrac\Express\Tools\EQCmd.exe')
    end
    it "shows correct eqcmd path from parameters" do
      stub_const('ENV', ENV.to_hash.merge('EQ_EQCMD_PATH' => 'eq_eqcmd_path'))
      eq = EquitracUtilities::Connection.new({eqcmd_path: 'params_eqcmd_path'})
      expect(eq.eqcmd_path).to eq('params_eqcmd_path')
    end
    it "shows correct eqcmd path from environment" do
      stub_const('ENV', ENV.to_hash.merge('EQ_EQCMD_PATH' => 'eq_eqcmd_path'))
      eq = EquitracUtilities::Connection.new
      expect(eq.eqcmd_path).to eq(ENV['EQ_EQCMD_PATH'])
    end
    it "shows default ssh options" do
      stub_const('ENV', ENV.to_hash.merge('EQ_SSH_OPTIONS' => nil))
      eq = EquitracUtilities::Connection.new
      expect(eq.ssh_options).to eq({})
    end
    it "shows ssh options from parameters" do
      eq = EquitracUtilities::Connection.new({ssh_options: {password: 'ssh_password'}})
      expect(eq.ssh_options).to eq({password: 'ssh_password'})
    end
    it "shows ssh options from parameters" do
      stub_const('ENV', ENV.to_hash.merge('EQ_SSH_OPTIONS' => '{verify_host_key: false}'))
      eq = EquitracUtilities::Connection.new
      expect(eq.ssh_options).to eq({verify_host_key: false})
    end
    it "ssh options parameters override environment" do
      stub_const('ENV', ENV.to_hash.merge('EQ_SSH_OPTIONS' => '{verify_host_key: false}'))
      eq = EquitracUtilities::Connection.new({ssh_options: {password: 'ssh_password'}})
      expect(eq.ssh_options).to eq({password: 'ssh_password'})
    end
    it "ssh options are empty" do
      stub_const('ENV', ENV.to_hash.merge('EQ_SSH_OPTIONS' => nil))
      eq = EquitracUtilities::Connection.new
      expect(eq.ssh_options).to eq({})
    end
  end
  context "server parameters are not correct" do
    it "errors when hostname is missing" do
      stub_const('ENV', ENV.to_hash.merge('EQ_HOSTNAME' => nil))
      expect { EquitracUtilities::Connection.new }.to raise_error(ArgumentError, /hostname missing/)
    end
    it "errors when username is missing" do
      stub_const('ENV', ENV.to_hash.merge('EQ_USERNAME' => nil))
      expect { EquitracUtilities::Connection.new }.to raise_error(ArgumentError, /username missing/)
    end
    it "errors when servicename is missing" do
      stub_const('ENV', ENV.to_hash.merge('EQ_SERVICENAME' => nil))
      expect { EquitracUtilities::Connection.new }.to raise_error(ArgumentError, /servicename missing/)
    end
    it "uses default eqcmd_path when env var is missing" do
      stub_const('ENV', ENV.to_hash.merge('EQ_EQCMD_PATH' => nil))
      eq = EquitracUtilities::Connection.new
      expect(eq.eqcmd_path).to eq 'C:\Program Files\Equitrac\Express\Tools\EQCmd.exe'
    end
  end
  context "it can connect via SSH needs ENV VARS configured" do
    it "returns expected SSH results" do
      eq = EquitracUtilities::Connection.new
      expect(eq.send(:send_eqcmd, 'echo "HI!"')).to match(/HI/)
    end
  end
  context "it"
end

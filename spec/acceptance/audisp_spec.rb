require 'spec_helper_acceptance'

describe 'include auditd::audisp' do
  audit_v2 = ['centos7', 'debian10', 'redhat7', 'scientific7', 'ubuntu20', 'ubuntu18']
  test_os = [os[:family], os[:release].to_i].join('')

  # @note: auditd doesn't work well with containers. local_events is disabled
  # for the service to run and allow rudimentary tests to be performed.
  pp = <<-MANIFEST
    $config = lookup('auditd::config')

    class { 'auditd':
      config => deep_merge($config, {
        local_events => 'no',
      }),
    }

    include auditd::audisp
  MANIFEST

  it 'applies idempotently' do
    if test_os == 'redhat9'
      # EL9 transient kernel permission race on first restart inside a container
      begin
        idempotent_apply(pp)
      rescue RuntimeError
        idempotent_apply(pp)
      end
    else
      idempotent_apply(pp)
    end
  end

  if audit_v2.include?(test_os)
    describe file('/etc/audisp/') do
      it { is_expected.to exist }
      it { is_expected.to be_directory }
      it { is_expected.to be_mode 7_50 }
      it { is_expected.to be_owned_by 'root' }
    end

    describe file('/etc/audisp/plugins.d/') do
      it { is_expected.to exist }
      it { is_expected.to be_directory }
      it { is_expected.to be_mode 7_50 }
      it { is_expected.to be_owned_by 'root' }
    end
  else
    describe file('/etc/audisp/') do
      it { is_expected.not_to exist }
    end

    describe file('/etc/audisp/plugins.d/') do
      it { is_expected.not_to exist }
    end
  end

  describe file('/sbin/audispd') do
    it { is_expected.to exist }
    it { is_expected.to be_file }
    it { is_expected.to be_mode 7_50 }
    it { is_expected.to be_owned_by 'root' }
  end
end

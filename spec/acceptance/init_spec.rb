require 'spec_helper_acceptance'

describe 'include class' do
  # @note: auditd doesn't work well with containers. local_events is disabled
  # for the service to run and allow rudimentary tests to be performed.
  pp = <<-MANIFEST
    $config = lookup('auditd::config')

    class { 'auditd':
      config => deep_merge($config, {
        local_events => 'no',
      }),
      rules => {
        insmod => {
          content => '-w /sbin/insmod -p x -k modules',
          order   => 10,
        },
      },
      plugins => {
        auoms => {
          active => 'no',
          path   => '/opt/microsoft/auoms/bin/auomscollect',
        },
      },
    }

    auditd::rule { '-w /var/run/utmp -p wa -k session': }

    auditd::plugin { 'clickhouse':
      active    => 'yes',
      direction => 'out',
      path      => '/usr/libexec/auditd-plugin-clickhouse',
      type      => 'always',
      args      => '/etc/audit/auditd-clickhouse.conf',
      format    => 'string',
    }
  MANIFEST

  it 'applies idempotently' do
    idempotent_apply(pp)
  end

  describe file('/etc/audit/') do
    it { is_expected.to exist }
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 7_50 }
    it { is_expected.to be_owned_by 'root' }
  end

  describe file('/etc/audit/plugins.d/') do
    it { is_expected.to exist }
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 7_50 }
    it { is_expected.to be_owned_by 'root' }
  end

  describe file('/etc/audit/rules.d/') do
    it { is_expected.to exist }
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 7_50 }
    it { is_expected.to be_owned_by 'root' }
  end

  describe file('/etc/audit/auditd.conf') do
    it { is_expected.to exist }
    it { is_expected.to be_file }
    it { is_expected.to be_mode 6_00 }
    it { is_expected.to be_owned_by 'root' }
  end

  describe file('/etc/audit/rules.d/audit.rules') do
    it { is_expected.to exist }
    it { is_expected.to be_file }
    it { is_expected.to be_mode 6_00 }
    it { is_expected.to be_owned_by 'root' }
    its(:content) do
      is_expected.to match(%r{-w /sbin/insmod -p x -k modules})
      is_expected.to match(%r{-w /var/run/utmp -p wa -k session})
    end
  end

  describe file('/etc/audit/plugins.d/clickhouse.conf') do
    it { is_expected.to exist }
    it { is_expected.to be_file }
    it { is_expected.to be_mode 6_00 }
    it { is_expected.to be_owned_by 'root' }
    its(:content) do
      is_expected.to match(%r{active = yes})
      is_expected.to match(%r{direction = out})
      is_expected.to match(%r{path = /usr/libexec/auditd-plugin-clickhouse})
      is_expected.to match(%r{type = always})
      is_expected.to match(%r{args = /etc/audit/auditd-clickhouse.conf})
      is_expected.to match(%r{format = string})
    end
  end

  describe file('/etc/audit/plugins.d/auoms.conf') do
    it { is_expected.to exist }
    it { is_expected.to be_file }
    it { is_expected.to be_mode 6_00 }
    it { is_expected.to be_owned_by 'root' }
    its(:content) do
      is_expected.to match(%r{active = no})
      is_expected.to match(%r{direction = out})
      is_expected.to match(%r{path = /opt/microsoft/auoms/bin/auomscollect})
      is_expected.to match(%r{type = always})
      is_expected.to match(%r{format = string})
    end
  end

  describe service('auditd') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end

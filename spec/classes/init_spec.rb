require 'spec_helper'

describe 'auditd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('auditd') }
        it { is_expected.to create_class('auditd::service') }
        it { is_expected.to create_class('auditd::package') }
        it { is_expected.to create_class('auditd::config') }

        it { is_expected.to contain_class('auditd') }
        it { is_expected.to contain_class('auditd::service') }
        it { is_expected.to contain_class('auditd::package') }
        it { is_expected.to contain_class('auditd::config') }

        it { is_expected.to contain_service('auditd') }

        if facts[:os]['family'] == 'Debian'
          it { is_expected.to contain_package('auditd') }
        end

        if facts[:os]['family'] == 'RedHat'
          it { is_expected.to contain_package('audit') }
        end

        it { is_expected.to contain_file('/etc/audit/auditd.conf') }
        it { is_expected.to contain_concat('/etc/audit/rules.d/audit.rules') }
        it { is_expected.to contain_concat__fragment('auditd_rules_begin') }
        it { is_expected.to contain_concat__fragment('auditd_rules_end') }

        it { is_expected.to contain_file('/etc/audisp/plugins.d/syslog.conf') }
        it { is_expected.to contain_file('/sbin/audispd') }
      end
    end
  end
end

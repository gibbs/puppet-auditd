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

        it { is_expected.to contain_file('/etc/audit/').with_ensure('directory') }
        it { is_expected.to contain_file('/etc/audit/plugins.d/').with_ensure('directory') }
        it { is_expected.to contain_file('/etc/audit/rules.d/').with_ensure('directory') }

        it { is_expected.to contain_file('/etc/audit/auditd.conf') }
        it { is_expected.to contain_concat('/etc/audit/rules.d/audit.rules') }
        it { is_expected.to contain_concat__fragment('auditd_rules_begin') }
        it { is_expected.to contain_concat__fragment('auditd_rules_end') }

        context 'documentation example' do
          let(:params) do
            {
              rules: {
                insmod: {
                  content: '-w /sbin/insmod -p x -k modules',
                  order:   10,
                },
                sudoers_changes: {
                  content: '-w /etc/sudoers -p wa -k scope',
                  order:   50,
                },
              },
              plugins: {
                auoms: {
                  active: 'no',
                  direction: 'out',
                  path: '/opt/microsoft/auoms/bin/auomscollect',
                },
                clickhouse: {
                  active: 'yes',
                  direction: 'out',
                  path: '/usr/libexec/auditd-plugin-clickhouse',
                  args: '/etc/audit/auditd-clickhouse.conf',
                },
              },
            }
          end

          it { is_expected.to compile }
        end
      end
    end
  end
end

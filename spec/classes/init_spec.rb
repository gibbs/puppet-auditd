require 'spec_helper'

describe 'auditd' do
  context 'supported operating systems' do
    audit_v2 = ['CentOS7', 'Debian10', 'RedHat7', 'Scientific7', 'Ubuntu20.04', 'Ubuntu18.04']
    audit_v3 = ['AlmaLinux8', 'Debian11', 'RedHat8', 'Rocky8', 'Ubuntu22.04']

    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        test_os = [facts[:os]['name'], facts[:os]['release']['major']].join('')

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

        if audit_v2.include?(test_os)
          it { is_expected.not_to contain_file('auditd-auditd-plugin-syslog.conf') }
        end

        if audit_v3.include?(test_os)
          it { is_expected.to contain_file('auditd-auditd-plugin-syslog.conf') }
        end

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
          it { is_expected.to contain_auditd__plugin('auoms') }
          it { is_expected.to contain_file('auditd-auditd-plugin-auoms.conf') }

        end

        context 'with service_override set to valid value' do
          let(:params) { { service_override: 'testing' } }

          it {
            is_expected.to contain_file('/etc/systemd/system/auditd.service.d').only_with(
              'ensure' => 'directory',
              'owner'  => 0,
              'group'  => 0,
              'mode'   => '0750',
            )
          }

          it {
            is_expected.to contain_file('/etc/systemd/system/auditd.service.d/override.conf').only_with(
              'ensure'  => 'file',
              'owner'   => 0,
              'group'   => 0,
              'mode'    => '0640',
              'content' => 'testing',
            )
          }
        end
      end
    end
  end
end

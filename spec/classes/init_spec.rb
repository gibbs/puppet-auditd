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

        context 'with buffer_size set to valid value' do
          let(:params) { { buffer_size: 242 } }

          it { is_expected.to contain_concat__fragment('auditd_rules_begin').with_content(%r{^-b 242$}) }
        end

        context 'with failure_mode set to valid value' do
          let(:params) { { failure_mode: 2 } }

          it { is_expected.to contain_concat__fragment('auditd_rules_begin').with_content(%r{^-f 2$}) }
        end

        context 'with immutable set to valid value' do
          let(:params) { { immutable: true } }

          it { is_expected.to contain_concat__fragment('auditd_rules_end').with_content(%r{^-e 2$}) }
        end

        context 'with dir set to valid value' do
          let(:params) { { dir: '/test/ing' } }

          it { is_expected.to contain_file('/test/ing') }
        end

        context 'with mode set to valid value' do
          let(:params) { { mode: '0242' } }

          it { is_expected.to contain_file('/etc/audit').with_mode('0242') }
        end

        context 'with owner set to valid string value' do
          let(:params) { { owner: 'test' } }

          it { is_expected.to contain_file('/etc/audit').with_owner('test') }
        end

        context 'with owner set to valid integer value' do
          let(:params) { { owner: 242 } }

          it { is_expected.to contain_file('/etc/audit').with_owner(242) }
        end

        context 'with group set to valid string value' do
          let(:params) { { group: 'test' } }

          it { is_expected.to contain_file('/etc/audit').with_group('test') }
        end

        context 'with group set to valid integer value' do
          let(:params) { { group: 242 } }

          it { is_expected.to contain_file('/etc/audit').with_group(242) }
        end

        context 'with config set to valid value' do
          let(:params) { { 'config': { 'log_file' => '/test/ing' } } }

          it { is_expected.to contain_file('/etc/audit/auditd.conf').with_content(%r{log_file = \/test\/ing}) }
        end

        context 'with config_path set to valid value' do
          let(:params) { { config_path: '/test/ing' } }

          it { is_expected.to contain_file('/test/ing') }
        end

        context 'with config_mode set to valid value' do
          let(:params) { { config_mode: '0242' } }

          it { is_expected.to contain_file('/etc/audit/auditd.conf').with_mode('0242') }
        end

        context 'with config_owner set to valid string value' do
          let(:params) { { config_owner: 'test' } }

          it { is_expected.to contain_file('/etc/audit/auditd.conf').with_owner('test') }
        end

        context 'with config_owner set to valid integer value' do
          let(:params) { { config_owner: 242 } }

          it { is_expected.to contain_file('/etc/audit/auditd.conf').with_owner(242) }
        end

        context 'with config_group set to valid string value' do
          let(:params) { { config_group: 'test' } }

          it { is_expected.to contain_file('/etc/audit/auditd.conf').with_group('test') }
        end

        context 'with config_group set to valid integer value' do
          let(:params) { { config_group: 242 } }

          it { is_expected.to contain_file('/etc/audit/auditd.conf').with_group(242) }
        end

        context 'with package_name set to valid value' do
          let(:params) { { package_name: 'testing' } }

          it { is_expected.to contain_package('testing') }
        end

        context 'with package_ensure set to valid value' do
          let(:params) { { package_ensure: '2.4.2' } }

          os_package = if facts[:os]['family'] == 'RedHat'
                         'audit'
                       else
                         'auditd'
                       end

          it { is_expected.to contain_package(os_package).with_ensure('2.4.2') }
        end

        context 'with package_manage set to valid value' do
          let(:params) { { package_manage: false } }

          it { is_expected.not_to contain_package('auditd') }
        end

        context 'with service_enable set to valid value' do
          let(:params) { { service_enable: false } }

          it { is_expected.to contain_service('auditd').with_enable(false) }
        end

        context 'with service_ensure set to valid value' do
          let(:params) { { service_ensure: 'stopped' } }

          it { is_expected.to contain_service('auditd').with_ensure('stopped') }
        end

        context 'with service_manage set to valid value' do
          let(:params) { { service_manage: false } }

          it { is_expected.not_to contain_service('audit') }  # RedHat
          it { is_expected.not_to contain_service('auditd') } # others
        end

        context 'with service_name set to valid value' do
          let(:params) { { service_name: 'audit4' } }

          it { is_expected.to contain_service('audit4') }
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

        context 'with plugin_dir set to valid value' do
          let(:params) { { plugin_dir: '/test/ing' } }

          it { is_expected.to contain_file('/test/ing') }
        end

        context 'with plugin_dir_mode set to valid value' do
          let(:params) { { plugin_dir_mode: '0242' } }

          it { is_expected.to contain_file('/etc/audit/plugins.d').with_mode('0242') }
        end

        context 'with plugin_dir_owner set to valid string value' do
          let(:params) { { plugin_dir_owner: 'test' } }

          it { is_expected.to contain_file('/etc/audit/plugins.d').with_owner('test') }
        end

        context 'with plugin_dir_owner set to valid integer value' do
          let(:params) { { plugin_dir_owner: 242 } }

          it { is_expected.to contain_file('/etc/audit/plugins.d').with_owner(242) }
        end

        context 'with plugin_dir_group set to valid string value' do
          let(:params) { { plugin_dir_group: 'test' } }

          it { is_expected.to contain_file('/etc/audit/plugins.d').with_group('test') }
        end

        context 'with plugin_dir_group set to valid integer value' do
          let(:params) { { plugin_dir_group: 242 } }

          it { is_expected.to contain_file('/etc/audit/plugins.d').with_group(242) }
        end

        context 'with plugins set to valid value' do
          let(:params) do
            {
              plugins: {
                test1: {
                  active: 'no',
                  direction: 'out',
                  path: '/test/ing1',
                },
                test2: {
                  active: 'yes',
                  direction: 'out',
                  path: '/test/ing2',
                },
              },
            }
          end

          it {
            is_expected.to contain_auditd__plugin('test1').with(
              'active'    => 'no',
              'direction' => 'out',
              'path'      => '/test/ing1',
            )
          }

          it {
            is_expected.to contain_auditd__plugin('test2').with(
              'active'    => 'yes',
              'direction' => 'out',
              'path'      => '/test/ing2',
            )
          }

          it { is_expected.to contain_file('auditd-auditd-plugin-test1.conf') } # only needed for 100% resource coverage
          it { is_expected.to contain_file('auditd-auditd-plugin-test2.conf') } # only needed for 100% resource coverage
        end

        context 'with rules_dir set to valid value' do
          let(:params) { { rules_dir: '/test/ing' } }

          it { is_expected.to contain_file('/test/ing') }
        end

        context 'with rules_dir_mode set to valid value' do
          let(:params) { { rules_dir_mode: '0242' } }

          it { is_expected.to contain_file('/etc/audit/rules.d').with_mode('0242') }
        end

        context 'with rules_dir_owner set to valid string value' do
          let(:params) { { rules_dir_owner: 'test' } }

          it { is_expected.to contain_file('/etc/audit/rules.d').with_owner('test') }
        end

        context 'with rules_dir_owner set to valid integer value' do
          let(:params) { { rules_dir_owner: 242 } }

          it { is_expected.to contain_file('/etc/audit/rules.d').with_owner(242) }
        end

        context 'with rules_dir_group set to valid string value' do
          let(:params) { { rules_dir_group: 'test' } }

          it { is_expected.to contain_file('/etc/audit/rules.d').with_group('test') }
        end

        context 'with rules_dir_group set to valid integer value' do
          let(:params) { { rules_dir_group: 242 } }

          it { is_expected.to contain_file('/etc/audit/rules.d').with_group(242) }
        end

        context 'with rules_file set to valid value' do
          let(:params) { { rules_file: '/test/ing' } }

          it { is_expected.to contain_concat('/test/ing') }
          it { is_expected.to contain_concat__fragment('auditd_rules_begin').with_target('/test/ing') }
          it { is_expected.to contain_concat__fragment('auditd_rules_end').with_target('/test/ing') }
        end

        context 'with rules_file set to valid value when rules is also set' do
          let(:params) { { rules_file: '/test/ing', rules: { test5: {} } } }

          it { is_expected.to contain_concat__fragment('auditd_fragment_test5').with_target('/test/ing') }
          it { is_expected.to contain_auditd__rule('test5') } # only needed for 100% resource coverage
        end

        context 'with rules set to valid value' do
          let(:params) do
            {
              rules: {
                test3: {
                  content: 'testing3',
                },
                test4: {
                  content: 'testing4',
                  order:   50,
                },
              },
            }
          end

          it {
            is_expected.to contain_auditd__rule('test3').only_with(
              'content' => 'testing3',
              'order'   => 10,
            )
          }

          it {
            is_expected.to contain_auditd__rule('test4').only_with(
              'content' => 'testing4',
              'order'   => 50,
            )
          }

          it { is_expected.to contain_concat__fragment('auditd_fragment_test3') } # only needed for 100% resource coverage
          it { is_expected.to contain_concat__fragment('auditd_fragment_test4') } # only needed for 100% resource coverage
        end
      end
    end
  end
end

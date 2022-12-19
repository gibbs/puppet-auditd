require 'spec_helper'

describe 'auditd::audisp' do
  context 'supported operating systems' do
    audit_v2 = ['CentOS7', 'Debian10', 'RedHat7', 'Scientific7', 'Ubuntu20.04', 'Ubuntu18.04']
    audit_v3 = ['AlmaLinux8', 'Debian11', 'RedHat8', 'Rocky8', 'Ubuntu22.04']

    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        test_os = [facts[:os]['name'], facts[:os]['release']['major']].join('')

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('auditd::audisp') }
        it { is_expected.to contain_package('audispd-plugins').only_with_ensure('installed') }

        if audit_v2.include?(test_os)
          it {
            is_expected.to contain_file('/etc/audisp').only_with(
              'ensure' => 'directory',
              'owner'  => 0,
              'group'  => 0,
              'mode'   => '0750',
            )
          }

          it {
            is_expected.to contain_file('/etc/audisp/plugins.d').only_with(
              'ensure' => 'directory',
              'owner'  => 0,
              'group'  => 0,
              'mode'   => '0750',
            )
          }

          content = <<-END.gsub(%r{^\s+\|}, '')
            |# THIS FILE IS MANAGED BY PUPPET
            |
            |q_depth = 250
            |overflow_action = syslog
            |priority_boost = 4
            |max_restarts = 10
            |name_format = hostname
            |plugin_dir = /etc/audisp/plugins.d/
          END
          it {
            is_expected.to contain_file('/etc/audisp/audispd.conf').only_with(
              'ensure'  => 'file',
              'owner'   => 0,
              'group'   => 0,
              'mode'    => '0600',
              'content' => content,
            )
          }

          it { is_expected.to contain_file('auditd-audisp-plugin-syslog.conf').with_path('/etc/audisp/plugins.d/syslog.conf') }

          it {
            is_expected.to contain_auditd__plugin('af_unix').only_with(
              'active'      => 'no',
              'direction'   => 'out',
              'path'        => 'builtin_af_unix',
              'type'        => 'builtin',
              'args'        => '0640 /var/run/audispd_events',
              'format'      => 'string',
              'plugin_type' => 'audisp',
              # default parameters from auditd::plugin
              'mode'        => '0600',
              'owner'       => 0,
              'group'       => 0,
            )
          }
          it { is_expected.to contain_file('auditd-audisp-plugin-af_unix.conf') }

          it {
            is_expected.to contain_auditd__plugin('au-remote').only_with(
              'active'    => 'no',
              'direction' => 'out',
              'path'      => '/sbin/audisp-remote',
              'type'      => 'always',
              'format'    => 'string',
              'plugin_type' => 'audisp',
              # default parameters from auditd::plugin
              'mode'        => '0600',
              'owner'       => 0,
              'group'       => 0,
            )
          }
          it { is_expected.to contain_file('auditd-audisp-plugin-au-remote.conf') }

          it {
            is_expected.to contain_auditd__plugin('audispd-zos-remote').only_with(
              'active'      => 'no',
              'direction'   => 'out',
              'path'        => '/sbin/audispd-zos-remote',
              'type'        => 'always',
              'args'        => '/etc/audisp/zos-remote.conf',
              'format'      => 'string',
              'plugin_type' => 'audisp',
              # default parameters from auditd::plugin
              'mode'        => '0600',
              'owner'       => 0,
              'group'       => 0,
            )
          }
          it { is_expected.to contain_file('auditd-audisp-plugin-audispd-zos-remote.conf') }

          if facts[:os]['family'] == 'Debian'
            it {
              is_expected.to contain_auditd__plugin('au-prelude').only_with(
                'active'      => 'no',
                'direction'   => 'out',
                'path'        => '/sbin/audisp-prelude',
                'type'        => 'always',
                'format'      => 'string',
                'plugin_type' => 'audisp',
                # default parameters from auditd::plugin
                'mode'        => '0600',
                'owner'       => 0,
                'group'       => 0,
              )
            }
            it { is_expected.to contain_file('auditd-audisp-plugin-au-prelude.conf') }

            it {
              is_expected.to contain_auditd__plugin('syslog').only_with(
                'active'      => 'no',
                'direction'   => 'out',
                'path'        => 'builtin_syslog',
                'type'        => 'builtin',
                'args'        => 'LOG_INFO',
                'format'      => 'string',
                'plugin_type' => 'audisp',
                # default parameters from auditd::plugin
                'mode'        => '0600',
                'owner'       => 0,
                'group'       => 0,
              )
            }
            it { is_expected.to contain_file('auditd-audisp-plugin-syslog.conf') }
          else
            it {
              is_expected.to contain_auditd__plugin('syslog').only_with(
                'active'      => 'no',
                'direction'   => 'out',
                'path'        => '/sbin/audisp-syslog',
                'type'        => 'always',
                'args'        => 'LOG_INFO',
                'format'      => 'string',
                'plugin_type' => 'audisp',
                # default parameters from auditd::plugin
                'mode'        => '0600',
                'owner'       => 0,
                'group'       => 0,
              )
            }
          end
        end

        if audit_v3.include?(test_os)
          it { is_expected.not_to contain_file('/etc/audisp/').with_ensure('directory') }
          it { is_expected.not_to contain_file('/etc/audisp/plugins.d').with_ensure('directory') }
          it { is_expected.not_to contain_file('/etc/audisp/audispd.conf') }
          it { is_expected.not_to contain_file('auditd-audisp-plugin-syslog.conf') }
          if facts[:os]['family'] == 'Debian'
            it { is_expected.to contain_file('auditd-auditd-plugin-af_unix.conf') }
            it { is_expected.to contain_file('auditd-auditd-plugin-au-remote.conf') }
            it { is_expected.to contain_file('auditd-auditd-plugin-audispd-zos-remote.conf') }
          end
        end

        it {
          is_expected.to contain_file('/sbin/audispd').only_with(
            'ensure'  => 'file',
            'mode'    => '0750',
          )
        }
      end

      context "on #{os} with dir set to valid value" do
        let(:params) { { dir: '/test/ing' } }

        it { is_expected.to contain_file('/test/ing') }
      end

      context "on #{os} with mode set to valid value" do
        let(:params) { { mode: '0242' } }

        it { is_expected.to contain_file('/etc/audisp').with_mode('0242') }
      end

      context "on #{os} with owner set to valid string value" do
        let(:params) { { owner: 'test' } }

        it { is_expected.to contain_file('/etc/audisp').with_owner('test') }
      end

      context "on #{os} with owner set to valid integer value" do
        let(:params) { { owner: 242 } }

        it { is_expected.to contain_file('/etc/audisp').with_owner(242) }
      end

      context "on #{os} with group set to valid string value" do
        let(:params) { { group: 'test' } }

        it { is_expected.to contain_file('/etc/audisp').with_group('test') }
      end

      context "on #{os} with group set to valid integer value" do
        let(:params) { { group: 242 } }

        it { is_expected.to contain_file('/etc/audisp').with_group(242) }
      end

      context "on #{os} with config set to valid value" do
        let(:params) do
          {
            'config': {
              'q_depth'         => 242,
              'overflow_action' => 'IGNORE',
              'priority_boost'  => 3,
              'max_restarts'    => 23,
              'name_format'     => 'hostname',
              'plugin_dir'      => '/test/ing/',
            }
          }
        end

        audispd_conf__content = <<-END.gsub(%r{^\s+\|}, '')
          |# THIS FILE IS MANAGED BY PUPPET
          |
          |q_depth = 242
          |overflow_action = IGNORE
          |priority_boost = 3
          |max_restarts = 23
          |name_format = hostname
          |plugin_dir = /test/ing/
        END
        it { is_expected.to contain_file('/etc/audisp/audispd.conf').with_content(audispd_conf__content) }
      end

      context "on #{os} with config_path set to valid value" do
        let(:params) { { config_path: '/test/ing' } }

        it { is_expected.to contain_file('/test/ing').with_notify(nil) } # created by this class
      end

      context "on #{os} with config_path set to same value as auditd::config_path" do
        let(:params) { { config_path: '/etc/audit/auditd.conf' } }

        it { is_expected.to contain_file('/etc/audit/auditd.conf').with_notify('Service[auditd]') } # created by auditd::config
      end

      context "on #{os} with config_mode set to valid value" do
        let(:params) { { config_mode: '0242' } }

        it { is_expected.to contain_file('/etc/audisp/audispd.conf').with_mode('0242') }
      end

      context "on #{os} with config_owner set to valid string value" do
        let(:params) { { config_owner: 'test' } }

        it { is_expected.to contain_file('/etc/audisp/audispd.conf').with_owner('test') }
      end

      context "on #{os} with config_owner set to valid integer value" do
        let(:params) { { config_owner: 242 } }

        it { is_expected.to contain_file('/etc/audisp/audispd.conf').with_owner(242) }
      end

      context "on #{os} with config_group set to valid string value" do
        let(:params) { { config_group: 'test' } }

        it { is_expected.to contain_file('/etc/audisp/audispd.conf').with_group('test') }
      end

      context "on #{os} with config_group set to valid integer value" do
        let(:params) { { config_group: 242 } }

        it { is_expected.to contain_file('/etc/audisp/audispd.conf').with_group(242) }
      end

      context "on #{os} with package_name set to valid value" do
        let(:params) { { package_name: 'testing' } }

        it { is_expected.to contain_package('testing') }
      end

      context "on #{os} with package_ensure set to valid value" do
        let(:params) { { package_ensure: '2.4.2' } }

        it { is_expected.to contain_package('audispd-plugins').with_ensure('2.4.2') }
      end

      context "on #{os} with package_manage set to valid value" do
        let(:params) { { package_manage: false } }

        it { is_expected.not_to contain_package('audispd-plugins') }
      end

      context "on #{os} with plugin_dir set to valid value" do
        let(:params) { { plugin_dir: '/test/ing' } }

        it { is_expected.to contain_file('/test/ing') } # created by this class
      end

      context "on #{os} with plugin_dir set to same value as auditd::plugin_dir" do
        let(:params) { { plugin_dir: '/etc/audit/plugins.d' } }

        it { is_expected.to contain_file('/etc/audit/plugins.d') } # created by auditd::config
      end

      context "on #{os} with plugin_dir_mode set to valid value" do
        let(:params) { { plugin_dir_mode: '0242' } }

        it { is_expected.to contain_file('/etc/audisp/plugins.d').with_mode('0242') }
      end

      context "on #{os} with plugin_dir_owner set to valid string value" do
        let(:params) { { plugin_dir_owner: 'test' } }

        it { is_expected.to contain_file('/etc/audisp/plugins.d').with_owner('test') }
      end

      context "on #{os} with plugin_dir_owner set to valid integer value" do
        let(:params) { { plugin_dir_owner: 242 } }

        it { is_expected.to contain_file('/etc/audisp/plugins.d').with_owner(242) }
      end

      context "on #{os} with plugin_dir_group set to valid string value" do
        let(:params) { { plugin_dir_group: 'test' } }

        it { is_expected.to contain_file('/etc/audisp/plugins.d').with_group('test') }
      end

      context "on #{os} with plugin_dir_group set to valid integer value" do
        let(:params) { { plugin_dir_group: 242 } }

        it { is_expected.to contain_file('/etc/audisp/plugins.d').with_group(242) }
      end

      context "on #{os} with plugins set to valid value" do
        let(:params) { { 'plugins': { 'test': { 'path' => '/test/ing' } } } }

        it do
          is_expected.to contain_auditd__plugin('test').only_with(
            'path'        => '/test/ing',
            'plugin_type' => 'audisp',
            # default parameters from auditd::plugin
            'active'      => 'yes',
            'direction'   => 'out',
            'type'        => 'always',
            'format'      => 'string',
            'mode'        => '0600',
            'owner'       => 0,
            'group'       => 0,
          )
        end

        it { is_expected.to contain_file('auditd-audisp-plugin-test.conf') }
      end
    end
  end
end

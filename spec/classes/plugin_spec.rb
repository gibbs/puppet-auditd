require 'spec_helper'

describe 'auditd::plugin', type: :define do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:pre_condition) { 'include ::auditd' }

        context 'clickhouse plugin example' do
          let(:title) { 'clickhouse' }
          let(:params) do
            {
              active: 'yes',
              direction: 'out',
              path: '/usr/libexec/auditd-plugin-clickhouse',
              type: 'always',
              args: '/etc/audit/auditd-clickhouse.conf',
              format: 'string'
            }
          end

          it { is_expected.to compile }

          content = <<-END.gsub(%r{^\s+\|}, '')
            |# THIS FILE IS MANAGED BY PUPPET
            |active = yes
            |direction = out
            |path = /usr/libexec/auditd-plugin-clickhouse
            |type = always
            |args = /etc/audit/auditd-clickhouse.conf
            |format = string
          END
          it {
            is_expected.to contain_file('auditd-auditd-plugin-clickhouse.conf').only_with(
              'ensure'  => 'file',
              'path'    => '/etc/audit/plugins.d/clickhouse.conf',
              'mode'    => '0600',
              'owner'   => 0,
              'group'   => 0,
              'content' => content,
              'notify'  => 'Service[auditd]',
            )
          }
        end

        context "on #{os}" do
          let(:title) { 'testing' }

          context 'with path set to valid value' do
            let(:params) { { path: '/test/ing' } }

            it { is_expected.to contain_file('auditd-auditd-plugin-testing.conf').with_content(%r{path = /test/ing}) }
          end

          context 'with active set to valid value when mandatory parameters are also set' do
            let(:params) { { active: 'no', path: '/test/ing' } }

            it { is_expected.to contain_file('auditd-auditd-plugin-testing.conf').with_content(%r{active = no}) }
          end

          context 'with direction set to valid value when mandatory parameters are also set' do
            let(:params) { { direction: 'in', path: '/test/ing' } }

            it { is_expected.to contain_file('auditd-auditd-plugin-testing.conf').with_content(%r{direction = in}) }
          end

          context 'with type set to valid value when mandatory parameters are also set' do
            let(:params) { { type: 'builtin', path: '/test/ing' } }

            it { is_expected.to contain_file('auditd-auditd-plugin-testing.conf').with_content(%r{type = builtin}) }
          end

          context 'with args set to valid value when mandatory parameters are also set' do
            let(:params) { { args: 'testing', path: '/test/ing' } }

            it { is_expected.to contain_file('auditd-auditd-plugin-testing.conf').with_content(%r{args = testing}) }
          end

          context 'with format set to valid value when mandatory parameters are also set' do
            let(:params) { { format: 'binary', path: '/test/ing' } }

            it { is_expected.to contain_file('auditd-auditd-plugin-testing.conf').with_content(%r{format = binary}) }
          end

          context 'with mode set to valid value when mandatory parameters are also set' do
            let(:params) { { mode: '0242', path: '/test/ing' } }

            it { is_expected.to contain_file('auditd-auditd-plugin-testing.conf').with_mode('0242') }
          end

          context 'with owner set to valid string value when mandatory parameters are also set' do
            let(:params) { { owner: 'test', path: '/test/ing' } }

            it { is_expected.to contain_file('auditd-auditd-plugin-testing.conf').with_owner('test') }
          end

          context 'with owner set to valid integer value when mandatory parameters are also set' do
            let(:params) { { owner: 242, path: '/test/ing' } }

            it { is_expected.to contain_file('auditd-auditd-plugin-testing.conf').with_owner(242) }
          end

          context 'with group set to valid string value when mandatory parameters are also set' do
            let(:params) { { group: 'test', path: '/test/ing' } }

            it { is_expected.to contain_file('auditd-auditd-plugin-testing.conf').with_group('test') }
          end

          context 'with group set to valid integer value when mandatory parameters are also set' do
            let(:params) { { group: 242, path: '/test/ing' } }

            it { is_expected.to contain_file('auditd-auditd-plugin-testing.conf').with_group(242) }
          end
        end
      end
    end
  end
end

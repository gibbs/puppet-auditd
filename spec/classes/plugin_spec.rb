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
          it {
            is_expected.to contain_file('auditd-auditd-plugin-clickhouse.conf').with(
              'ensure' => 'file',
              'path'   => '/etc/audit/plugins.d/clickhouse.conf',
              'owner'  => 0,
              'group'  => 0,
              'mode'   => '0600',
            )
          }
        end
      end
    end
  end
end

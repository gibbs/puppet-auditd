require 'spec_helper'

describe 'auditd::rule', type: :define do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:pre_condition) { 'include ::auditd' }

        context 'with default values for parameters' do
          let(:title) { '-w /var/run/utmp -p wa -k session' }

          it { is_expected.to compile }
          it {
            is_expected.to create_concat__fragment('auditd_fragment_-w /var/run/utmp -p wa -k session').only_with(
              'target'  => '/etc/audit/rules.d/audit.rules',
              'order'   => 10,
              'content' => "-w /var/run/utmp -p wa -k session\n\n",
            )
          }
        end

        context 'with content set to empty string' do
          let(:title) { 'testing' }
          let(:params) { { content: '' } }

          it { is_expected.to create_concat__fragment('auditd_fragment_testing').with_content(%r{testing\n\n}) }
        end

        context 'with content set to valid value' do
          let(:title) { 'testing' }
          let(:params) { { content: 'test' } }

          it { is_expected.to create_concat__fragment('auditd_fragment_testing').with_content(%r{# testing\ntest\n\n}) }
        end

        context 'with order set to valid value' do
          let(:title) { 'testing' }
          let(:params) { { order: 3 } }

          it { is_expected.to create_concat__fragment('auditd_fragment_testing').with_order(3) }
        end

        # real life examples
        context 'insmod rule' do
          let(:title) { 'insmod' }
          let(:params) { { 'content' => '-w /sbin/insmod -p x -k modules' } }

          it {
            is_expected.to create_concat__fragment('auditd_fragment_insmod').with(
              'content' => "# insmod\n-w /sbin/insmod -p x -k modules\n\n",
            )
          }
        end

        context 'sudoers_changes rule' do
          let(:title) { 'sudoers_changes' }
          let(:params) do
            {
              'content' => '-w /etc/sudoers -p wa -k scope',
              'order'   => 50,
            }
          end

          it {
            is_expected.to create_concat__fragment('auditd_fragment_sudoers_changes').only_with(
              'target'  => '/etc/audit/rules.d/audit.rules',
              'order'   => 50,
              'content' => "# sudoers_changes\n-w /etc/sudoers -p wa -k scope\n\n",
            )
          }
        end
      end
    end
  end
end

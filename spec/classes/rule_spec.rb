require 'spec_helper'

# rubocop:disable Layout/FirstHashElementIndentation
describe 'auditd::rule', type: :define do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:pre_condition) { 'include ::auditd' }

        context 'empty content' do
          let(:title) { '-w /var/run/utmp -p wa -k session' }

          it {
            is_expected.to compile
            is_expected.to create_concat__fragment('auditd_fragment_-w /var/run/utmp -p wa -k session').with({
              content: "-w /var/run/utmp -p wa -k session\n\n"
            })
          }
        end

        context 'insmod rule' do
          let(:title) { 'insmod' }
          let(:params) do
            {
              'content' => '-w /sbin/insmod -p x -k modules',
            }
          end

          it {
            is_expected.to compile
            is_expected.to create_concat__fragment('auditd_fragment_insmod').with({
              content: "# insmod\n-w /sbin/insmod -p x -k modules\n\n"
            })
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
            is_expected.to compile
            is_expected.to create_concat__fragment('auditd_fragment_sudoers_changes').with({
              content: "# sudoers_changes\n-w /etc/sudoers -p wa -k scope\n\n"
            })
          }
        end
      end
    end
  end
end

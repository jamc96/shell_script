require 'spec_helper'

describe 'shell_script' do
  permission_scripts = {
    'foo' => { 'path' => ['/foo'], 'owner' => 'foo', 'group' => 'foo'},
    'bar' => { 'path' => ['/var','/bar'], 'owner' => 'bar', 'group' => 'bar'}
  }
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { 'permission_scripts' => permission_scripts, } }
      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
      # main directory
      it { is_expected.to contain_file('/root/permission').with_ensure('directory') }
    end
  end
end

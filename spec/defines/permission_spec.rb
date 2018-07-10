require 'spec_helper'

describe 'shell_script::permission' do
  context "with no parameters" do 
    let(:title) { 'foo' }

    it { is_expected.to compile.and_raise_error(%r{Defined Type\[shell_script::permission\]: parameter 'path' expects a match for string value}) }
  end
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'foo' }
      let(:params) { { 'path' => ['/foo','/bar'], 'owner' => 'tor', 'group' => 'tor', 'mode' => '700'} }

      # validate manifest syntax
      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
      # validate file script
      it {
        is_expected.to contain_file('/root/permission/foo.sh') \
          .with(ensure: 'present', owner: 'root', group: 'root', mode: '0500') \
          .with_content(%r{^OWNER[=]?[a-z]+$}) \
          .with_content(%r{^GROUP[=]?[a-z]+$}) \
          .with_content(%r{^MODE[=]?\d{3}$})
      }
      if os_facts[:operatingsystem] == 'CentOS' && os_facts[:operatingsystemmajrelease] == '7'
        it { is_expected.to contain_file('/root/permission/foo.sh').with(validate_cmd: '/usr/bin/sh -n %') }
      else
        it { is_expected.to contain_file('/root/permission/foo.sh').with(validate_cmd: '/bin/sh -n %') }
      end
      # validate execution
      it {
        is_expected.to contain_exec('/root/permission/foo.sh') \
          .with(command: 'sh /root/permission/foo.sh', refreshonly: true, path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin') \
          .that_subscribes_to('File[/root/permission/foo.sh]')
      }
    end
  end
end

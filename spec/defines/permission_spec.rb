require 'spec_helper'

describe 'shell_script::permission' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'foo' }
      let(:params) { { 'path' => '/bar'} }

      # validate manifest syntax
      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
      # main directory
      it { is_expected.to contain_file('/root/permission').with_ensure('directory') }
      # validate file script
      it { is_expected.to contain_file('/root/permission/foo.sh') \
        .with( ensure: 'present', owner: 'root', group: 'root', mode: '0500',)
      }
      it { is_expected.to contain_file('/root/permission/foo.sh') \
        .with_content(%r{^DIRECTORY[=]?[/]\w+})
      }
      it { is_expected.to contain_file('/root/permission/foo.sh') \
        .with_content(%r{^OWNER[=]?[a-z]+$})
      }
      it { is_expected.to contain_file('/root/permission/foo.sh') \
        .with_content(%r{^GROUP[=]?[a-z]+$})
      }
      it { is_expected.to contain_file('/root/permission/foo.sh') \
        .with_content(%r{^MODE[=]?\d{3}$})
      }
      it { is_expected.to contain_file('/root/permission/foo.sh').that_requires('File[/root/permission]') }

      case os_facts[:operatingsystem]
      when 'CentOS'
        if os_facts[:operatingsystemmajrelease] == '7'
          it { is_expected.to contain_file('/root/permission/foo.sh').with(validate_cmd: '/usr/bin/sh -n %') }
        end
      else
        it { is_expected.to contain_file('/root/permission/foo.sh').with(validate_cmd: '/bin/sh -n %') }
      end

    end
  end
end

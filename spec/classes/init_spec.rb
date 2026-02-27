# frozen_string_literal: true

require 'spec_helper'

describe 'play' do
  on_supported_os.each do |os, os_facts|
    # Skip Windows — module uses Linux-only paths and service types
    next if os.match?(%r{windows}i)

    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('play') }
        it { is_expected.to contain_class('play::params') }
        it { is_expected.to contain_class('play::config') }
        it { is_expected.to contain_class('play::install') }

        # Default parameter values
        it { is_expected.to contain_class('play').with_user('play') }
        it { is_expected.to contain_class('play').with_group('play') }
        it { is_expected.to contain_class('play').with_home('/home/play') }
        it { is_expected.to contain_class('play').with_configdir('/home/play/conf') }
        it { is_expected.to contain_class('play').with_package_manage(false) }
        it { is_expected.to contain_class('play').with_service_manage(false) }
        it { is_expected.to contain_class('play').with_service_name('play') }
      end

      context 'config resources with defaults' do
        it { is_expected.to contain_file('configurations').with_ensure('directory') }
        it { is_expected.to contain_file('configurations').with_path('/home/play/conf') }
        it { is_expected.to contain_file('configurations').with_owner('play') }
        it { is_expected.to contain_file('configurations').with_group('play') }
        it { is_expected.to contain_file('configurations').with_mode('0750') }

        it { is_expected.to contain_file('logs').with_ensure('directory') }
        it { is_expected.to contain_file('logs').with_path('/var/log/play') }
        it { is_expected.to contain_file('logs').with_mode('0750') }

        it { is_expected.to contain_file('assets').with_ensure('directory') }
        it { is_expected.to contain_file('assets').with_path('/home/play/assets') }

        it { is_expected.to contain_file('documents').with_ensure('directory') }
        it { is_expected.to contain_file('documents').with_path('/home/play/documents') }

        it { is_expected.to contain_file('/home/play/heapdumps').with_ensure('directory') }
        it { is_expected.to contain_file('/home/play/heapdumps').with_owner('play') }
        it { is_expected.to contain_file('/home/play/heapdumps').with_mode('0700') }

        it { is_expected.to contain_file('application.conf').with_ensure('file') }
        it { is_expected.to contain_file('application.conf').with_path('/home/play/conf/application.conf') }
        it { is_expected.to contain_file('application.conf').with_mode('0640') }

        it do
          is_expected.to contain_file('application.conf')
            .with_content(%r{include "/etc/play/application.conf"})
        end

        it do
          is_expected.to contain_file('application.conf')
            .with_content(%r{http\.port=9000})
        end

        it { is_expected.to contain_file('logger.xml').with_ensure('file') }
        it { is_expected.to contain_file('logger.xml').with_path('/home/play/conf/logger.xml') }

        it do
          is_expected.to contain_file('logger.xml')
            .with_content(%r{<file>/var/log/play/logback\.log</file>})
        end

        # Service file should NOT exist when service_manage is false
        it { is_expected.not_to contain_file('servicefile') }
        it { is_expected.not_to contain_exec('systemd-daemon-reload') }
      end

      context 'with package_manage disabled (default)' do
        it { is_expected.not_to contain_package('play') }
        it { is_expected.not_to contain_service('play') }
      end

      context 'with custom user and group' do
        let(:params) do
          {
            user: 'myapp',
            group: 'mygroup',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('configurations').with_owner('myapp') }
        it { is_expected.to contain_file('configurations').with_group('mygroup') }
        it { is_expected.to contain_file('logs').with_owner('myapp') }
        it { is_expected.to contain_file('logs').with_group('mygroup') }
        it { is_expected.to contain_file('/home/myapp/heapdumps').with_owner('myapp') }
        it { is_expected.to contain_file('/home/myapp/heapdumps').with_ensure('directory') }
      end

      context 'with custom home directory' do
        let(:params) do
          {
            home: '/opt/play',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('configurations').with_path('/opt/play/conf') }
        it { is_expected.to contain_file('assets').with_path('/opt/play/assets') }
        it { is_expected.to contain_file('documents').with_path('/opt/play/documents') }
        it { is_expected.to contain_file('application.conf').with_path('/opt/play/conf/application.conf') }
        it { is_expected.to contain_file('logger.xml').with_path('/opt/play/conf/logger.xml') }
        it { is_expected.to contain_file('/opt/play/heapdumps').with_ensure('directory') }
      end

      context 'with custom config_params' do
        let(:params) do
          {
            config_params: {
              'http.port' => '8080',
              'play.http.secret.key' => 'changeme',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('application.conf')
            .with_content(%r{http\.port=8080})
        end

        it do
          is_expected.to contain_file('application.conf')
            .with_content(%r{play\.http\.secret\.key=changeme})
        end
      end

      context 'with include_defaults disabled in play::config' do
        let(:pre_condition) do
          "class { 'play::config': include_defaults => false }"
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('application.conf')
            .without_content(%r{^include })
        end
      end

      # Package/service/apt tests only make sense on Debian-family
      if os_facts[:os]['family'] == 'Debian'
        context 'with service_manage and package_manage enabled' do
          let(:params) do
            {
              package_manage: true,
              service_manage: true,
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_package('play').with_ensure('latest') }
          it { is_expected.to contain_service('play').with_enable(true) }
          it { is_expected.to contain_package('play').that_notifies('File[servicefile]') }
          it { is_expected.to contain_service('play').that_subscribes_to('File[application.conf]') }
          it { is_expected.to contain_file('servicefile') }
          it { is_expected.to contain_exec('systemd-daemon-reload').with_refreshonly(true) }

          # systemd service template content
          it do
            is_expected.to contain_file('servicefile')
              .with_content(%r{Description=play web application})
          end

          it do
            is_expected.to contain_file('servicefile')
              .with_content(%r{User=play})
          end

          it do
            is_expected.to contain_file('servicefile')
              .with_content(%r{ExecStart=/usr/share/play/bin/play})
          end

          it do
            is_expected.to contain_file('servicefile')
              .without_content(%r{JAVA_OPTS})
          end
        end

        context 'with jvm_opts set' do
          let(:params) do
            {
              package_manage: true,
              service_manage: true,
              jvm_opts: '-Xmx4g -Xms2g',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it do
            is_expected.to contain_file('servicefile')
              .with_content(%r{Environment="JAVA_OPTS=-Xmx4g -Xms2g"})
          end
        end

        context 'with custom service_name' do
          let(:params) do
            {
              service_name: 'myplayapp',
              package_manage: true,
              service_manage: true,
              package_name: 'myplayapp',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_package('myplayapp') }
          it { is_expected.to contain_service('myplayapp') }
          it { is_expected.to contain_file('logs').with_path('/var/log/myplayapp') }

          it do
            is_expected.to contain_file('servicefile')
              .with_content(%r{Description=myplayapp web application})
          end
        end

        context 'with repo_manage enabled' do
          let(:params) do
            {
              package_manage: true,
              repo_manage: true,
              repo_location: 'http://apt.example.com',
              repo_trusted: true,
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('apt') }

          it do
            is_expected.to contain_apt__source('play')
              .with_location('http://apt.example.com')
              .with_allow_unsigned(true)
          end
        end

        context 'with package_manage but service_manage disabled' do
          let(:params) do
            {
              package_manage: true,
              service_manage: false,
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_package('play').with_provider('apt') }
          it { is_expected.not_to contain_service('play') }
          it { is_expected.not_to contain_file('servicefile') }
        end
      end # Debian-family only

      context 'with invalid parameter types' do
        context 'user is not a string' do
          let(:params) { { user: 123 } }

          it { is_expected.not_to compile }
        end

        context 'home is not an absolute path' do
          let(:params) { { home: 'relative/path' } }

          it { is_expected.not_to compile }
        end

        context 'package_manage is not a boolean' do
          let(:params) { { package_manage: 'yes' } }

          it { is_expected.not_to compile }
        end
      end
    end
  end
end

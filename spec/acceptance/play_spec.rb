# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'play class' do
  context 'with default parameters' do
    let(:pp) do
      <<-MANIFEST
      group { 'play':
        ensure => present,
      }
      user { 'play':
        ensure     => present,
        gid        => 'play',
        home       => '/home/play',
        managehome => true,
      }
      class { 'play':
        require => User['play'],
      }
      MANIFEST
    end

    it 'applies without errors' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'applies idempotently' do
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/home/play/conf') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by('play') }
    end

    describe file('/var/log/play') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by('play') }
    end

    describe file('/home/play/assets') do
      it { is_expected.to be_directory }
    end

    describe file('/home/play/documents') do
      it { is_expected.to be_directory }
    end

    describe file('/home/play/heapdumps') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode('700') }
    end

    describe file('/home/play/conf/application.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(%r{include "/etc/play/application.conf"}) }
      its(:content) { is_expected.to match(%r{http\.port=9000}) }
    end

    describe file('/home/play/conf/logger.xml') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(%r{<file>/var/log/play/logback\.log</file>}) }
    end
  end

  context 'with custom parameters' do
    let(:pp) do
      <<-MANIFEST
      group { 'myapp':
        ensure => present,
      }
      user { 'myapp':
        ensure     => present,
        gid        => 'myapp',
        home       => '/opt/myapp',
        managehome => true,
      }
      class { 'play':
        user          => 'myapp',
        group         => 'myapp',
        home          => '/opt/myapp',
        service_name  => 'myapp',
        config_params => { 'http.port' => '8080' },
        require       => User['myapp'],
      }
      MANIFEST
    end

    it 'applies without errors' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'applies idempotently' do
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/opt/myapp/conf') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by('myapp') }
    end

    describe file('/var/log/myapp') do
      it { is_expected.to be_directory }
    end

    describe file('/opt/myapp/heapdumps') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode('700') }
    end

    describe file('/opt/myapp/conf/application.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(%r{http\.port=8080}) }
    end
  end
end

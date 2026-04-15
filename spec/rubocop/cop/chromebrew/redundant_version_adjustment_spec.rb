RSpec.describe RuboCop::Cop::Chromebrew::RedundantVersionAdjustment, :config do
  it 'does not register an offense when the version is never used after creation' do
    expect_no_offenses(<<~RUBY)
      class Foo < Package
        version '0.2.11'
      end
    RUBY
  end

  it 'does not register an offense when not in a package or buildsystem' do
    expect_no_offenses(<<~RUBY)
      class Foobark < Banannas
        version '0.2.11'
        git_hashtag version.delete_prefix('release-')
      end
    RUBY
  end

  it 'does not register an offense when the version is not modified' do
    expect_no_offenses(<<~RUBY)
      class Bar < Package
        version '72a'
        git_hashtag version
      end
    RUBY
  end

  it 'does not register an offense when the version is not modified inside an interpolated string' do
    expect_no_offenses(<<~'RUBY')
      class Florb < Package
        version '3.h.1'
        git_hashtag "v#{version}"
      end
    RUBY
  end

  it 'does not register an offense when external version constants are used' do
    expect_no_offenses(<<~'RUBY')
      class Gcc_lib < Package
        version '15.2.0'
        license Gcc_build.license

        puts "#{self} version (#{version}) differs from gcc version #{Gcc_build.version}".orange if version != Gcc_build.version
      end
    RUBY
  end

  it 'does not register an offense when the version is usefully modified inside an interpolated string' do
    expect_no_offenses(<<~'RUBY')
      class Flop < Package
        version '1.2.a'

        git_hashtag "v#{version.rpartition('.')[0]}"
      end
    RUBY
  end

  it 'does not register an offense when the version is usefully modified inside an interpolated string in an install_extras block' do
    expect_no_offenses(<<~'RUBY')
      class Gettext < Autotools
        version '1.0-1'

        autotools_install_extras do
          downloader "https://github.com/autotools-mirror/gettext/raw/refs/tags/v#{version.split('-')[0]}/gettext-tools/autotools/archive.dir.tar", 'e32c5de9b39a70092e9a82e83ebffb4c0a8c698cf3acbdcbb4902dfebdf767f8', "#{CREW_DEST_PREFIX}/share/gettext/archive.dir.tar"
        end
      end
    RUBY
  end

  it 'registers an offense when the version is uselessly modified' do
    expect_offense(<<~RUBY)
      class Greb < CMake
        version '0.2.12'
        git_hashtag version.delete_prefix('release-')
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^ This version adjustment does not actually change the version.
      end
    RUBY

    expect_correction(<<~RUBY)
      class Greb < CMake
        version '0.2.12'
        git_hashtag version
      end
    RUBY
  end

  it 'registers an offense when the version is uselessly modified inside an interpolated string' do
    expect_offense(<<~'RUBY')
      class Qux < Package
        version '123'
        git_hashtag "v#{version.split('-').first}"
                               ^^^^^^^^^^^^^^^^^ This version adjustment does not actually change the version.
      end
    RUBY

    expect_correction(<<~'RUBY')
      class Qux < Package
        version '123'
        git_hashtag "v#{version}"
      end
    RUBY
  end

  it 'registers an offense when the version is uselessly modified in a buildsystem' do
    expect_offense(<<~'RUBY')
      class Quux < CMake
        version '4.0.10'
        git_hashtag "R#{version.gsub('-', '_')}"
                               ^^^^^^^^^^^^^^^ This version adjustment does not actually change the version.
      end
    RUBY

    expect_correction(<<~'RUBY')
      class Quux < CMake
        version '4.0.10'
        git_hashtag "R#{version}"
      end
    RUBY
  end

  it 'registers an offense when the version is uselessly modified inside a complex interpolated string' do
    expect_offense(<<~'RUBY')
      class Fleep < Package
        version '0.2.11'
        git_hashtag version

        FileUtils.ln_sf "#{CREW_LIB_PREFIX}/wx/config/gtk3-unicode-#{version.split('-')[0].sub(/\.\d+$/, '')}", "#{CREW_DEST_PREFIX}/bin/wx-config"
                                                                            ^^^^^^^^^^^^^^ This version adjustment does not actually change the version.
        FileUtils.ln_sf "#{CREW_PREFIX}/bin/wxrc-#{version.split('-')[0].sub(/\.\d+$/, '')}", "#{CREW_DEST_PREFIX}/bin/wxrc"
                                                          ^^^^^^^^^^^^^^ This version adjustment does not actually change the version.
      end
    RUBY

    expect_correction(<<~'RUBY')
      class Fleep < Package
        version '0.2.11'
        git_hashtag version

        FileUtils.ln_sf "#{CREW_LIB_PREFIX}/wx/config/gtk3-unicode-#{version.sub(/\.\d+$/, '')}", "#{CREW_DEST_PREFIX}/bin/wx-config"
        FileUtils.ln_sf "#{CREW_PREFIX}/bin/wxrc-#{version.sub(/\.\d+$/, '')}", "#{CREW_DEST_PREFIX}/bin/wxrc"
      end
    RUBY
  end
end

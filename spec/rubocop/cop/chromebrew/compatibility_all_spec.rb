RSpec.describe RuboCop::Cop::Chromebrew::CompatibilityAll, :config do
  it 'registers an offense when all four architectures are listed' do
    expect_offense(<<~'RUBY')
      compatibility 'aarch64 armv7l i686 x86_64'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Compatibility properties which match all architectures should be replaced with 'all'
    RUBY

    expect_correction(<<~'RUBY')
      compatibility 'all'
    RUBY
  end

  it 'registers an offense when all four architectures are listed with commas' do
    expect_offense(<<~'RUBY')
      compatibility 'aarch64, armv7l, i686, x86_64'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Compatibility properties which match all architectures should be replaced with 'all'
    RUBY

    expect_correction(<<~'RUBY')
      compatibility 'all'
    RUBY
  end

  it 'registers an offense when all four architectures are listed in a different order' do
    expect_offense(<<~'RUBY')
      compatibility 'i686 armv7l x86_64 aarch64'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Compatibility properties which match all architectures should be replaced with 'all'
    RUBY

    expect_correction(<<~'RUBY')
      compatibility 'all'
    RUBY
  end

  it 'does not register an offense when only some architectures are listed' do
    expect_no_offenses(<<~'RUBY')
      compatibility 'i686 x86_64'
    RUBY
  end
end

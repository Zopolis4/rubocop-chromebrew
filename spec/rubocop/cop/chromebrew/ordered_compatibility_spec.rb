RSpec.describe RuboCop::Cop::Chromebrew::OrderedCompatibility, :config do
  it 'registers an offense when compatibiltiy is not in alphabetical order with three elements' do
    expect_offense(<<~'RUBY')
      compatibility 'x86_64 aarch64 armv7l'
                    ^^^^^^^^^^^^^^^^^^^^^^^ Compatibility values should be in alphabetical order.
    RUBY

    expect_correction(<<~'RUBY')
      compatibility 'aarch64 armv7l x86_64'
    RUBY
  end

  it 'registers an offense when compatibiltiy is not in alphabetical order with two elements' do
    expect_offense(<<~'RUBY')
      compatibility 'x86_64 i686'
                    ^^^^^^^^^^^^^ Compatibility values should be in alphabetical order.
    RUBY

    expect_correction(<<~'RUBY')
      compatibility 'i686 x86_64'
    RUBY
  end

  it 'does not register an offense when compatibility is in alphabetical order' do
    expect_no_offenses(<<~'RUBY')
      compatibility 'aarch64 armv7l x86_64'
    RUBY
  end

  it 'does not register an offense when compatibility is a single architecture' do
    expect_no_offenses(<<~'RUBY')
      compatibility 'x86_64'
    RUBY
  end

  it 'does not register an offense when compatibility is all' do
    expect_no_offenses(<<~'RUBY')
      compatibility 'all'
    RUBY
  end
end

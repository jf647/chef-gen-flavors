require 'chef_gen/flavor_base'

# :nocov:
module ChefGen
  module Flavor
    class Amazing < FlavorBase
      class << self
        def description
          'an amazing cookbook template'
        end
      end
    end
  end
  module Snippet
    module Bar
      def snippet_bar(_)
        @directories << 'bar'
      end
    end
  end
end
# :nocov:

RSpec.describe ChefGen::FlavorBase do
  include ChefDKGeneratorContext
  include DummyRecipe

  before do
    @orig_stdout = $stdout
    $stdout = File.open(File::NULL, 'w')
  end

  after do
    $stdout = @orig_stdout
  end

  it 'can be constructed' do
    template = ChefGen::Flavor::Amazing.new(@recipe)
    expect(template).to be_a ChefGen::FlavorBase
  end

  it 'creates files unconditionally' do
    include FakeFS::SpecHelpers

    expect(@recipe).to receive(:directory).once
    expect(@recipe).to receive(:cookbook_file).once
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.files << 'README.md'
    template.generate
  end

  it 'creates files conditionally with the clobber check enabled' do
    include FakeFS::SpecHelpers

    expect(@recipe).to receive(:directory).once
    expect(@recipe).not_to receive(:cookbook_file)
    expect(File).to receive(:exist?)
      .with('/nonexistent/foo/README.md')
      .and_return(true)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.fail_on_clobber = true
    template.files << 'README.md'
    expect { template.generate }
      .to output(/tried to overwrite file.+README\.md/).to_stderr
      .and raise_error
  end

  it 'creates files conditionally with the clobber check disabled' do
    include FakeFS::SpecHelpers

    expect(@recipe).to receive(:directory).once
    expect(@recipe).to receive(:cookbook_file).once
    expect(@ctx).to receive(:respond_to?).with(:clobber).and_return(true)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.files << 'README.md'
    template.generate
  end

  it 'creates templates unconditionally' do
    include FakeFS::SpecHelpers

    expect(@recipe).to receive(:directory).once
    expect(@recipe).to receive(:template).once
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.templates << 'README.md'
    template.generate
  end

  it 'creates templates conditionally with the clobber check enabled' do
    include FakeFS::SpecHelpers

    expect(@recipe).to receive(:directory).once
    expect(@recipe).not_to receive(:template)
    expect(File).to receive(:exist?)
      .with('/nonexistent/foo/README.md')
      .and_return(true)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.fail_on_clobber = true
    template.templates << 'README.md'
    expect { template.generate }
      .to output(/tried to overwrite file.+README\.md/).to_stderr
      .and raise_error
  end

  it 'creates templates conditionally with the clobber check disabled' do
    include FakeFS::SpecHelpers

    expect(@recipe).to receive(:directory).once
    expect(@recipe).to receive(:template).once
    expect(@ctx).to receive(:respond_to?).with(:clobber).and_return(true)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.templates << 'README.md'
    template.generate
  end

  it 'calls mixin methods' do
    include FakeFS::SpecHelpers

    expect(@recipe).to receive(:directory).with(/foo$/)
    expect(@recipe).to receive(:directory).with(%r{foo/bar$})
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.extend ChefGen::Snippet::Bar
    template.generate
  end

  it 'reports on actions by default' do
    include FakeFS::SpecHelpers

    expect(@recipe).to receive(:ruby_block).with('report_actions_taken')
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.files << 'README.md'
    template.generate
  end

  it 'does not report actions if disabled' do
    include FakeFS::SpecHelpers

    expect(@recipe).not_to receive(:ruby_block)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.report_actions = false
    template.files << 'README.md'
    template.generate
  end

  it 'displays the next steps if populated' do
    include FakeFS::SpecHelpers

    expect(@recipe).to receive(:ruby_block).with('display_next_steps')
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.report_actions = false
    template.next_steps = 'do something amazing'
    template.generate
  end

  it 'proxies to the ChefDK generator context' do
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.generator_context
  end
end

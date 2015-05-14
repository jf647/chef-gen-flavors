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
  before do
    @ctx = double('ChefDK generator context')
    allow(@ctx).to receive(:cookbook_root).and_return('/nonexistent')
    allow(@ctx).to receive(:cookbook_name).and_return('foo')
    allow(ChefDK::Generator).to receive(:context).and_return(@ctx)
    @recipe = double('Chef recipe').as_null_object
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
    expect(@recipe).to receive(:directory).once
    expect(@recipe).to receive(:cookbook_file).once
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.files << 'README.md'
    template.generate
  end

  it 'creates files conditionally with the clobber check enabled' do
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
    expect(@recipe).to receive(:directory).once
    expect(@recipe).to receive(:cookbook_file).once
    expect(@ctx).to receive(:respond_to?).with(:clobber).and_return(true)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.files << 'README.md'
    template.generate
  end

  it 'creates templates unconditionally' do
    expect(@recipe).to receive(:directory).once
    expect(@recipe).to receive(:template).once
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.templates << 'README.md'
    template.generate
  end

  it 'creates templates conditionally with the clobber check enabled' do
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
    expect(@recipe).to receive(:directory).once
    expect(@recipe).to receive(:template).once
    expect(@ctx).to receive(:respond_to?).with(:clobber).and_return(true)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.templates << 'README.md'
    template.generate
  end

  it 'accumulates .gitignore entries' do
    expect(@recipe).to receive(:file).with(/.gitignore$/)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.gitignore_files << 'foo'
    template.gitignore_files << 'bar'
    template.generate
  end

  it 'does not write a .gitignore if there are no entries' do
    expect(@recipe).not_to receive(:cookbook_file).with(/.gitignore$/)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.generate
  end

  it 'accumulates chefignore entries' do
    expect(@recipe).to receive(:file).with(/chefignore$/)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.chefignore_files << 'foo'
    template.chefignore_files << 'bar'
    template.generate
  end

  it 'does not write a chefignore if there are no entries' do
    expect(@recipe).not_to receive(:cookbook_file).with(/chefignore$/)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.generate
  end

  it 'calls mixin methods' do
    expect(@recipe).to receive(:directory).with(%r{foo/$})
    expect(@recipe).to receive(:directory).with(%r{foo/bar$})
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.extend ChefGen::Snippet::Bar
    template.generate
  end

  it 'reports on actions by default' do
    expect(@recipe).to receive(:ruby_block).with('report_actions_taken')
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.files << 'README.md'
    template.generate
  end

  it 'does not report actions if disabled' do
    expect(@recipe).not_to receive(:ruby_block)
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.report_actions = false
    template.files << 'README.md'
    template.generate
  end

  it 'displays the next steps if populated' do
    expect(@recipe).to receive(:ruby_block).with('display_next_steps')
    template = ChefGen::Flavor::Amazing.new(@recipe)
    template.report_actions = false
    template.next_steps = 'do something amazing'
    template.generate
  end
end

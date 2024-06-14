ignore(/bin/, /log/, /public/, /storage/, /tmp/)

group :development do
  guard :rspec, cmd: "bundle exec rspec" do
    watch("spec/.+_helper.rb") { "spec" }
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  end

  guard :bundler do
    require "guard/bundler"
    require "guard/bundler/verify"
    helper = Guard::Bundler::Verify.new

    files = ["Gemfile"]
    files += Dir["*.gemspec"] if files.any? { |f| helper.uses_gemspec?(f) }

    # Assume files are symlinked from somewhere
    files.each { |file| watch(helper.real_path(file)) }
  end
end

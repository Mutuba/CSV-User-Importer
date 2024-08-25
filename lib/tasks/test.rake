# frozen_string_literal: true

namespace :test do
  desc "Run only unit and controller tests"
  task run: :environment do
    Rake::Task["spec:models"].invoke
    Rake::Task["spec:controllers"].invoke
    Rake::Task["spec:services"].invoke
    Rake::Task["spec:validators"].invoke
    Rake::Task["spec:jobs"].invoke
  end
end

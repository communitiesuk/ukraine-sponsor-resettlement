namespace :cf do
  desc "Only run on the first application instance"
  task on_first_instance: :environment do
    # We expect this information to be always available or break otherwise
    instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"]
    exit(0) unless instance_index.zero?
  end
end

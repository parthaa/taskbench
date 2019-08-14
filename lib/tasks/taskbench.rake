namespace :taskbench do
  desc <<~END_DESC
    Loads up some tasks
  END_DESC
  def parallelize(param_lists)
    max_number_of_forks = ENV['forks']&.to_i || 10
    page = 0
    page_size = param_lists.length/max_number_of_forks
    page_size = param_lists.length % max_number_of_forks if page_size == 0
    loop do
      page += 1
      items = param_lists.paginate(:page => page, :per_page => page_size)
      break if items.empty?
      fork do
        puts "Forking New Process"
        items.each do |item|
          yield item
        end
      end
    end
  end

  def fetch_hosts
    count = ENV['count'].to_i || 10
    hosts = ::Host::Managed.unscoped.order('RANDOM()').limit(count)
  end

  task :hostupdate => :environment do
    puts 'Starting task load..'
    parallelize(fetch_hosts) do |host|
      begin
        User.current = User.anonymous_admin
        facts = host.facts
        task = ForemanTasks.async_task(::Actions::Katello::Host::Update, host, facts)
        puts "task: #{task} created"
      rescue StandardError => e
        puts "Exception launching task."
        puts e.message
        puts e.backtrace.inspect
      end
    end
    puts "Finished"
  end

  task :dummy => :environment do
    puts 'Starting dummy task load..'
    count = ENV['count'].to_i || 10
    parallelize((1..count).to_a) do |item|
        task = ForemanTasks.async_task(::TaskBench::DummyTask, 2)
        puts "task: #{task} created"
    end
  end

  task :genapp => :environment do
    puts 'Starting task load..'
    puts 'GenerateApplicability..'
    parallelize(fetch_hosts) do |host|
      begin
        User.current = User.anonymous_admin
        task = ForemanTasks.async_task(::Actions::Katello::Host::GenerateApplicability, [host])
        puts "task: #{y} created"
      rescue
        puts "Exception launching task."
      end
    end
    puts "Finished"
  end
end

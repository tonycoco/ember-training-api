RSpec.configure do |config|
  config.before(:suite) do |example|
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    if example.metadata[:js] || example.metadata[:test_commit]
      DatabaseCleaner.clean_with(:deletion)
    end

    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

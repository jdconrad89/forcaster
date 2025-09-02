# RSpec Testing Guide

This application uses RSpec for testing. The test suite covers the ForecastApi service, ForecastController, and related views.

## Test Structure

```
spec/
├── controllers/           # Controller tests
│   └── forecast_controller_spec.rb
├── factories/            # Factory definitions for test data
│   └── forecast_factory.rb
├── services/             # Service tests
│   └── forecast_api_spec.rb
├── views/                # View tests
│   └── forecast/index.html.erb_spec.rb
├── rails_helper.rb       # Rails-specific RSpec configuration
└── spec_helper.rb        # General RSpec configuration
```

## Running Tests

### Run all tests
```bash
bundle exec rspec
```

### Run specific test files
```bash
bundle exec rspec spec/services/forecast_api_spec.rb
bundle exec rspec spec/controllers/forecast_controller_spec.rb
bundle exec rspec spec/views/forecast/index.html.erb_spec.rb
```

### Run tests with specific tags
```bash
bundle exec rspec --tag focus
bundle exec rspec --tag slow
```

### Run tests with documentation format
```bash
bundle exec rspec --format documentation
```

### Run tests and generate coverage report
```bash
COVERAGE=true bundle exec rspec
```

## Test Coverage

### ForecastApi Service Tests
- **URL Construction**: Tests proper URL building with various zipcode formats
- **HTTParty Integration**: Verifies HTTParty module inclusion and method availability
- **Environment Variables**: Tests API key handling from environment
- **Error Handling**: Covers various edge cases and error scenarios
- **Logging**: Verifies proper logging of API requests and responses

### ForecastController Tests
- **Form Handling**: Tests form submission with various parameters
- **API Integration**: Verifies proper API calls and response handling
- **Caching**: Tests Rails cache integration and cache indicator logic
- **Error Handling**: Covers API failures and JSON parsing errors
- **Response Status**: Verifies proper HTTP response codes

### View Tests
- **Form Rendering**: Tests form fields, labels, and submission
- **Weather Display**: Verifies proper display of weather data
- **Cache Indicator**: Tests cache indicator visibility
- **Error Messages**: Verifies error message display
- **Accessibility**: Tests proper form labeling and field types

## Test Data Factories

The test suite uses FactoryBot to generate test data:

### Forecast Data Factory
```ruby
# Basic forecast data
create(:forecast_data)

# With specific traits
create(:forecast_data, :hot)
create(:forecast_data, :cold)
create(:forecast_data, :rainy)
create(:forecast_data, :windy)

# Location-specific data
create(:forecast_data, :new_york)
create(:forecast_data, :los_angeles)
create(:forecast_data, :chicago)
```

### Request Parameters Factory
```ruby
# Basic form parameters
create(:forecast_request_params)

# With specific traits
create(:forecast_request_params, :empty_fields)
create(:forecast_request_params, :partial_fields)
create(:forecast_request_params, :special_characters)
```

### API Error Response Factory
```ruby
# Basic error response
create(:api_error_response)

# With specific error types
create(:api_error_response, :invalid_zipcode)
create(:api_error_response, :rate_limit_exceeded)
create(:api_error_response, :server_error)
```

## Testing Best Practices

### Use Descriptive Test Names
```ruby
# Good
it 'handles empty zipcode gracefully'

# Bad
it 'works with empty input'
```

### Group Related Tests with Context
```ruby
context 'when zipcode is provided' do
  it 'makes API call'
  it 'displays weather data'
  it 'shows cache indicator'
end
```

### Use Let for Test Data
```ruby
let(:zipcode) { "27332" }
let(:forecast_api) { described_class.new(zipcode, endpoint) }
```

### Mock External Dependencies
```ruby
allow(HTTParty).to receive(:get).and_return(mock_response)
allow(Rails.cache).to receive(:fetch).and_return(cached_data)
```

### Test Edge Cases
```ruby
it 'handles nil values gracefully'
it 'handles empty arrays'
it 'handles special characters'
```

## Debugging Tests

### Run Single Test
```ruby
# Add this line to run only one test
fit 'should handle empty zipcode' do
  # test code
end
```

### Run Tests with Pry
```ruby
# Add this line to debug
require 'pry'; binding.pry
```

### View Test Output
```bash
bundle exec rspec --format documentation --color
```

## Continuous Integration

The test suite is designed to run in CI environments:

- Tests run in parallel for faster execution
- Random test order to catch order dependencies
- Proper cleanup of test data and stubs
- Environment variable handling for different environments

## Adding New Tests

When adding new functionality:

1. **Service Tests**: Add tests in `spec/services/`
2. **Controller Tests**: Add tests in `spec/controllers/`
3. **View Tests**: Add tests in `spec/views/`
4. **Factory Updates**: Update or add factories in `spec/factories/`
5. **Integration Tests**: Add tests in `spec/integration/` if needed

## Test Dependencies

The test suite requires these gems:
- `rspec-rails`: RSpec integration with Rails
- `factory_bot_rails`: Test data factories
- `faker`: Generate realistic test data
- `webmock`: Mock HTTP requests
- `vcr`: Record and replay HTTP interactions

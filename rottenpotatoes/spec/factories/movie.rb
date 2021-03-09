#define a way for Rspec to have data in psuedo database
FactoryBot.define do
  factory :movie do
    title {'Random Name'}
    rating {'R'}
    description {''}
    release_date {'1999-11-19'}
  end
end
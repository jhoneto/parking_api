FactoryBot.define do
  factory :parking do
    plate { "#{('A'..'Z').to_a.sample(3).join}-#{rand(1000..9999)}" }
    entry_time { Time.current }
    exit_time { nil }
    paid { false }

    trait :with_exit do
      exit_time { Time.current + 2.hours }
    end

    trait :paid do
      paid { true }
      exit_time { Time.current + 2.hours }
    end
  end
end

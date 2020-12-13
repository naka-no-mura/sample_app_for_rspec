FactoryBot.define do
  factory :task do
    sequence(:title){ "title_1" }
    content { 'テスト内容' }
    status { :todo }
    deadline { 1.week.from_now }
    user
  end
end
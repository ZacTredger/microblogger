
def random_short_lorem
  lorem = Faker::Lorem.sentence(word_count: rand(1..20))
  return lorem if lorem.length <= 140

  lorem[0...139].sub(/\s\w*$/, '.')
end

def random_created_at
  rand(1..4000).hours.ago
end

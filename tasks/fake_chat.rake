require 'yaml'
require 'csv'

ricks = Faker::Base.fetch_all("rick_and_morty.characters")
siths = Faker::StarWars.characters
PPL = (ricks + siths).shuffle.each_with_index.map{|p, index| {"id" => index, "name" => p}}

ricks_say = Faker::Base.fetch_all("rick_and_morty.quotes")
siths_say = Faker::StarWars.quotes
SAY = (ricks_say + siths_say).shuffle

def friends 
  ppl = PPL.clone
  friends = []
  while ppl.size > 1
    friends << ppl.pop(rand(2..6))
  end
  friends[0] += ppl  # if ppl.size > 0
  friends
end

def chat_participants 
  friends.map do |friend|
    friend.combination(2).to_a
  end.flatten(1)
end

def conv(chat_p)
  conv = []
  rand(5..100).times do
    from_to = chat_p.shuffle
    conv << {
      "from" => from_to[0],
      "to" => from_to[1],
      "time" => Faker::Time.backward(60, :all).iso8601,
      "message" => SAY.sample(rand(1..3)).join(" ")
    }
  end
  conv
end

def chat(chat_p)
  {
    "part" => chat_p,
    "conv" => conv(chap_p)
  }  
end



desc "Generate Fake Chat as yaml file"
task :as_yaml do

  all_chats = chat_participants.map {|chat| {"chat" => chat(chat)} }

  File.open("chats.yml", "w") do |f|
    f.write all_chats.to_yaml
  end
end

desc "Generate Fake Chat as CSV files"
task :as_csv do
  CSV.open("data/people.csv", "w") do |csv|
    csv << PPL.first.keys
    PPL.each do |h|
      csv << h.values
    end
  end

  all_conv = chat_participants.map{|chat_p| conv(chat_p) }.flatten(1)
  CSV.open("data/chats.csv", "w") do |csv|
    cnv = all_conv
    csv << cnv.first.keys
    cnv.each do |c|
      csv << [c["from"]["id"], c["to"]["id"], c["time"], c["message"]]
    end
  end

end
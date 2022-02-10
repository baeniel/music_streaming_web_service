require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'music.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'utf-8')
csv.each do |row|
  music = Music.new
  music.title = row['title']
  music.artist_name = row['artist_name']
  music.album_name = row['album_name']
  music.save
end
10.times do |index|
  User.create(email: "ringle_" + index.to_s + "@com", password: '111111', password_confirmation: "111111")
end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

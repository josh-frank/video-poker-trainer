Player.destroy_all
Player.reset_pk_sequence
PlayerHistory.destroy_all
PlayerHistory.reset_pk_sequence

start_seeding = Time.now

done_seeding = Time.now

puts "Seeded: #{ done_seeding - start_seeding }"
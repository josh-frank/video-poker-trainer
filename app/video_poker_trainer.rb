class VideoPokerTrainer

  def run
    interface = Interface.new
    welcome( interface )
    user = sign_in( interface )
    score = game_loop( interface )
    save_progress( user, score, interface )
    system "clear"
  end

  def welcome( interface )
    system "clear"
    royal_flushes = [ [ 52, 48, 44, 40, 36 ], [ 51, 47, 43, 39, 35 ], [ 50, 46, 42, 38, 34 ], [ 49, 45, 41, 37, 33 ] ]
    puts interface.hand_graphics( royal_flushes.sample )
    puts "\n         VIDEO POKER TRAINER"
    puts "\n            by JOSH FRANK"
    puts "\n  Train yourself to calculate poker"
    puts "   odds! Each hand has 32 possible"
    puts " choices... can you beat the house"
    puts " by picking the right cards to hold?"
    interface.prompt.keypress( "\n    (press any key to continue)" )
  end

  def sign_in( interface )
    system "clear"
    puts interface.hand_graphics( [ -1, -1, -1, -1, -1 ] )
    username = interface.prompt.ask( "Enter your username: " )
    user = Player.find_by( name: username )
    if !user
      puts "Hm, it seems you're a new player. Let's create a password!"
      interface.prompt.keypress( "(press any key to continue)" )
      user = create_new_user( username, interface )
    else
      puts "Welcome back, #{ user.name }!"
      correct_password = false
      until correct_password do
        password_attempt = interface.prompt.mask( "Enter your password: ", mask: "♣♦♥♠"[ rand( 0..3 ) ], required: true )
        if password_attempt == user.password
          puts "#{ user.name } has successfully signed in!"
          correct_password = true
        else
          puts "Incorrect password!"
        end
      end
    end
    interface.prompt.keypress( "(press any key to start playing)" )
    user
  end

  def create_new_user( new_user_name, interface )
    system "clear"
    puts interface.hand_graphics( [ -1, -1, -1, -1, -1 ] )
    puts "New player: #{ new_user_name }"
    password = interface.prompt.mask( "Enter a password: ", mask: "♣♦♥♠"[ rand( 0..3 ) ], required: true )
    confirmed_password = false
    until confirmed_password do
      confirm = interface.prompt.mask( "Confirm your password by entering it again: ", mask: "♣♦♥♠"[ rand( 0..3 ) ], required: true )
      if confirm != password
        puts "Password confirmation must match password!"
      else
        confirmed_password = true
      end
    end
    puts "New user #{ new_user_name } successfully created!"
    Player.create( name: new_user_name, password: password )
  end

  def game_loop( interface )
    # score = [ player_answers, correct_answers, right_holds, total_holds, average_time ]
    score = [ 0, 0, 0, 0, 0.0 ]
    score = play_round( score, interface )
    score = play_round( score, interface ) until !interface.prompt.yes?( "Keep playing? (y/n)" )
    score
  end

  def play_round( score, interface )
    system "clear"
    deck = ( 1..52 ).to_a.shuffle
    hand = deck.pop( 5 )
    puts interface.hand_graphics( hand )
    puts HandRank.category_key( HandRank.get( hand ) ).capitalize.gsub( "_", " " )
    all_holds = possible_average_hold_values( deck, hand )
    correct_hold = all_holds.max_by{ | hold, average_value | average_value }
    start_timer = Time.now
    user_hold = interface.get_hold( hand )
    stop_timer = Time.now
    correct = user_hold == correct_hold.first
    puts correct ? "Correct!" : "Incorrect! The correct choice was: #{ correct_hold.first.map( &:name ).join(", ") }"
    score[ 0 ] += all_holds[ user_hold ]
    score[ 1 ] += correct_hold[ 1 ]
    score[ 2 ] += correct ? 1 : 0
    score[ 3 ] += 1
    puts "Current score: #{ ( score[0] * 100.0 / score[1].to_f ).round( 3 ) }%"
    puts "#{ score[ 2 ] } out of #{ score[ 3 ] } correct answers so far"
    time = ( stop_timer - start_timer ).round( 3 )
    score[ 4 ] = ( ( score[ 4 ] + time ) / ( score[ 3 ] == 1 ? 1.0 : 2.0 ) ).round( 3 )
    puts "Answered in #{ time } seconds - average time so far: #{ score[ 4 ] } seconds"
    score
  end

  def save_progress( user, score, interface )
    previous_average_time = ( PlayerHistory.where( player_id: user.id ).sum( :average_time ) / PlayerHistory.where( player_id: user.id ).size.to_f ).round( 3 )
    PlayerHistory.create( player_id: user.id, player_answers: score[ 0 ], correct_answers: score[ 1 ], right_holds: score[ 2 ], total_holds: score[ 3 ], average_time: score[ 4 ] )
    current_history = PlayerHistory.where( player_id: user.id )
    current_average_time = ( current_history.sum( :average_time ) / current_history.size.to_f ).round( 3 )
    total_score = [ current_history.sum( :player_answers ), current_history.sum( :correct_answers ) ]
    change_in_average_time = current_average_time - previous_average_time
    system "clear"
    puts interface.hand_graphics( [ -1, -1, -1, -1, -1 ] )
    puts "Progress successfully saved!"
    puts "\nToday's score: #{ ( score[0] * 100.0 / score[1].to_f ).round( 3 ) }%"
    puts "#{ score[ 2 ] } correct answers out of #{ score[ 3 ] } hands"
    puts "\n#{ score[ 4 ] } sec. average response time this round."
    puts "Your average response time #{ change_in_average_time > 0 ? "rose" : "dropped" } by #{ change_in_average_time.abs.round( 3 ) } seconds." if current_history.size > 1
    puts "Your new score: #{ ( total_score[0] * 100.0 / total_score[1].to_f ).round( 3 ) }%"
    puts "\nTHANKS FOR PLAYING - UNTIL NEXT TIME!"
    interface.prompt.keypress( "(press any key to quit)" )
  end

  private

  def possible_hands( deck, hand_size, hold_cards = [] )
    hold_cards.each{ | hold_card | deck.delete( hold_card ) }
    deck.combination( hand_size - hold_cards.length ).to_a.map{ | hand | hand.concat( hold_cards ) }
  end

  def possible_holds( hand, number_of_hold_cards )
    hand.size.times.to_a.combination( number_of_hold_cards ).to_a.map{ | hold | hold.map{ | index | hand[ index ] } }
  end
 
  def all_possible_holds( hand )
    ( 0..hand.size ).to_a.collect{ | hold_size | possible_holds( hand, hold_size ) }.flatten( 1 )
  end
 
  def possible_average_hold_values( deck, hand )
    all_possible_holds( hand ).to_h do | hold |
       this_possibility = possible_hands( deck, hand.length, hold )
       [ hold, this_possibility.sum{ | hand | HandRank.get( hand ) } / this_possibility.length.to_f ]
    end
  end

end

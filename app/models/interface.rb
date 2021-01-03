# Extends class Integer to give card numbers awareness of their suit/rank
# and card name to facilitate creating ASCII graphics for hands
#                    A,  2,  3,  4,  5,  6,  7,  8,  9, 10,  J,  Q,  K,  A
#    clubs = [ nil, 49,  1,  5,  9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49 ]
# diamonds = [ nil, 50,  2,  6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50 ]
#   hearts = [ nil, 51,  3,  7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51 ]
#   spades = [ nil, 52,  4,  8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52 ]
class Integer
    @@ranks = [ "", "", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace" ]
    @@suits = [ "Clubs", "Diamonds", "Hearts", "Spades" ]
    def suit; ( self - 1 ) % 4; end
    def rank; ( ( self - 1 ) / 4 ) + 2; end
    def name; @@ranks[ self.rank ] + " of " + @@suits[ self.suit ]; end
end

class Interface

    @@suits = "♣♦♥♠"
    @@cards = [
        [ "╭─────╮",
          "│     │",
          "│     │",
          "│     │",
          "│     │",
          "╰─────╯" ],
        [ "╭─────╮",
          "│▞▞▞▞▞│",
          "│▞▞▞▞▞│",
          "│▞▞▞▞▞│",
          "│▞▞▞▞▞│",
          "╰─────╯" ],
        [ "╭─╴2╶─╮",
          "│  *  │",
          "│     │",
          "│     │",
          "│  *  │",
          "╰─────╯" ],
        [ "╭─╴3╶─╮",
          "│  *  │",
          "│  *  │",
          "│     │",
          "│  *  │",
          "╰─────╯" ],
        [ "╭─╴4╶─╮",
          "│*   *│",
          "│     │",
          "│     │",
          "│*   *│",
          "╰─────╯" ],
        [ "╭─╴5╶─╮",
          "│*   *│",
          "│  *  │",
          "│     │",
          "│*   *│",
          "╰─────╯" ],
        [ "╭─╴6╶─╮",
          "│*   *│",
          "│  *  │",
          "│  *  │",
          "│*   *│",
          "╰─────╯" ],
        [ "╭─╴7╶─╮",
          "│*   *│",
          "│  *  │",
          "│*   *│",
          "│*   *│",
          "╰─────╯" ],
        [ "╭─╴8╶─╮",
          "│*   *│",
          "│*   *│",
          "│*   *│",
          "│*   *│",
          "╰─────╯" ],
        [ "╭─╴9╶─╮",
          "│*   *│",
          "│* * *│",
          "│*   *│",
          "│*   *│",
          "╰─────╯" ],
        [ "╭─╴T╶─╮",
          "│*   *│",
          "│* * *│",
          "│* * *│",
          "│*   *│",
          "╰─────╯" ],
        [ "╭─╴J╶─╮",
          "│  *  │",
          "│ ◭◬◮ │",
          "│▝⋅╹⋅▘│",
          "│ ╘¯╛ │",
          "╰─────╯" ],
        [ "╭─╴Q╶─╮",
          "│  *  │",
          "│ ╭⍙╮ │",
          "│⎠◞⍣◟⎝│",
          "│ ╲¯╱ │",
          "╰─────╯" ],
        [ "╭─╴K╶─╮",
          "│  *  │",
          "│ ◣▲◢ │",
          "│◖◡▔◡◗│",
          "│ ⎩¯⎭ │",
          "╰─────╯" ],
        [ "╭─╴A╶─╮",
          "│ ╓─╖ │",
          "│ ║*║ │",
          "│ ║ ║ │",
          "│ ╙─╜ │",
          "╰─────╯" ] ]

    attr_reader :prompt

    def initialize
        @prompt = TTY::Prompt.new
    end

    def card_graphics( card )
        return @@cards[ 1 ] if card == -1
        result = [ "", "", "", "", "", "" ]
        6.times do | row |
          this_row = @@cards[ card.rank ][ row ].gsub( "*", @@suits[ card.suit ] )
          result[ row ] = ( 1..2 ).include?( card.suit ) ? this_row.colorize( :red ) : this_row
        end
        result
    end

    def hand_graphics( hand )
        result = [ "", "", "", "", "", "" ]
        hand.each do | card |
          6.times do | row |
            this_card = card_graphics( card )
            result[ row ] += this_card[ row ]
          end
        end
        result
    end

    def get_hold( hand )
        prompt.multi_select("Your hold? ", hand.map{ | card | [ card.name, card ] }.to_h )
    end

end

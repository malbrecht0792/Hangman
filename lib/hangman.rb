class Game

	def initialize(player_name)
		@player = Player.new(player_name)
		#Select a secret word
		select_word
		puts "Secret Word: #{@selected_word}"
		@guesses_left = @selected_word.length
		@board = Board.new(@selected_word)
		@board.display_board
		@continue_game = true
		game_loop
	end

	def select_word
		@selected_word = File.open("5desk.txt").readlines.sample.chomp
		unless @selected_word.length.between?(5,12)
			select_word
			return
		end
	end

	def game_loop
		while @continue_game
			turn
		end
	end

	def turn
		ask_to_save_game
		print "#{@player.name}, please select a letter: "
		@move = gets.chomp.downcase
		check_move
		@board.update_board(@selected_word, @move)
		update_guesses_left
		@board.display_board
		check_end_of_game
	end

	def check_move
		if @move.length != 1 || @move[/[a-zA-Z]/] != @move
			print "Invalid input! Please select a single letter: "
			@move = gets.chomp.downcase
			check_move
		end
	end

	def update_guesses_left
		unless @selected_word.include?(@move)
			@guesses_left -= 1
		end
		puts "Guesses Left: #{@guesses_left}"
	end

	def check_end_of_game
		unless @board.spaces.include?("_")
			puts "You guessed the secret word!"
			@continue_game = false
		end
		if @guesses_left == 0
			puts "You are out of guesses! Game over!"
			@continue_game = false
		end
	end

	def ask_to_save_game

	end

	def save_game

	end

	def ask_to_load_game

	end

	def load_game

	end

end

class Player

	attr_accessor :name

	def initialize(name)
		@name = name
	end
end

class Board

	attr_accessor :spaces

	def initialize(selected_word)
		@spaces = ""
		puts "length of selected_word: #{selected_word.length}"
		selected_word.length.times{ @spaces = @spaces + "_" }
	end

	def display_board
		displayed_board = ""
		@spaces.split("").each{|character| displayed_board =  displayed_board + " " + character + " "}
		puts "Board: #{displayed_board}"
	end

	def update_board(selected_word, move)
		selected_word.split("").each_with_index do |letter, index|
			if selected_word[index] == move
				@spaces[index] = move
			end
		end
	end

end

my_game = Game.new("Marcel")





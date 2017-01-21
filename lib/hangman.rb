require "json"
#JSON.load File.read("saved_game.json")

class Game

	attr_accessor :selected_word, :guesses_left, :continue_game

	def initialize(player_name)
		@player = Player.new(player_name)
		#Select a secret word
		select_word
		@guesses_left = @selected_word.length
		@board = Board.new(@selected_word)
		ask_to_load_game
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
		return if @continue_game == false
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
		print "Would you like to save this game and exit? (y/n): "
		if gets.chomp == "y"
			self.save_game
			@player.save_game
			@board.save_game
			@continue_game = false
		end
	end

	def save_game
		my_file = File.open("game.json", "w")
		my_file.puts JSON.dump ({
			:selected_word => @selected_word,
			:guesses_left => @guesses_left,
			:continue_game => @continue_game
		})
		my_file.close
	end

	def ask_to_load_game
		print "Would you like to load a previous game? (y/n): "
		if gets.chomp == "y"
			load_game(File.open("game.json", "r").read)
			@player.load_game(File.open("player.json", "r").read)
			@board.load_game(File.open("board.json", "r").read)
		end
	end

	def load_game(string)
		data = JSON.load string
		@selected_word = data["selected_word"]
		@guesses_left = data["guesses_left"]
		@continue_game = data["continue_game"]
	end

end

class Player

	attr_accessor :name

	def initialize(name)
		@name = name
	end

	def save_game
		my_file = File.open("player.json", "w")
		my_file.puts JSON.dump ({
			:name => @name
		})
		my_file.close
	end

	def load_game(string)
		data = JSON.load string
		self.name = data["name"]
	end
end

class Board

	attr_accessor :spaces

	def initialize(selected_word)
		@spaces = ""
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

	def save_game
		my_file = File.open("board.json", "w")
		my_file.puts JSON.dump ({
			:spaces => @spaces
		})
		my_file.close
	end
	def load_game(string)
		data = JSON.load string
		self.spaces = data["spaces"]
	end

end

my_game = Game.new("Marcel")





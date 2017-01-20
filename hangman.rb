

class Game

	def initialize(player_name)
		@player = Player.new(player_name)
		#Select a secret word
		select_word
		@continue_game = true
		game_loop
	end

	def select_word
		@selected_word = File.open("5desk.txt").readlines.sample
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
		puts "#{@player.name}, please select a letter"
		@move = gets.chomp.downcase
		check_move
		puts @move
	end

	def check_move
		if @move.length != 1 || @move[/[a-zA-Z]/] != @move
			puts "Invalid input! Please select a single letter"
			@move = gets.chomp.downcase
			check_move
		end
	end

end

class Player

	attr_accessor :name

	def initialize(name)
		@name = name
	end
end

my_game = Game.new("Marcel")





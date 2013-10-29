# Main file for Flashcards game

#Welcome to the game
puts "Welcome to Flashcards, built to test knowledge of Ruby. To play, simply enter the correct term for each definition."
puts "\n"
puts "To skip a question until later, simply type 'SKIP'"
puts "\n"
puts "To stop playing, simply type 'EXIT'"
puts "\n"
puts "Enjoy playing!"
puts "\n"

#Define game mechanics
class Game
	attr_reader :qa_pairs

	#Define @qa_pairs as the running list of Question and Answer pairs remaining to be asked
	#Define current_question and current_answer as the current pair being asked
	#Define text prompts
	def initialize(file)
		qa_pairs = []
		require 'csv'
		CSV.foreach(file) do |row|
			qa_pairs << row
		end
		@qa_pairs = Array.new
		qa_pairs.each_slice(3) { |a|
			@qa_pairs << [a[0], a[1]]
		}
		@current_question = nil
		@current_answer = nil
		@correct_msg = "Correct! Smart cookie!"
		@incorrect_msg = "Not quite...try again"
		@shutdown_msg = "Okay, shutting down. Thanks for playing!"
		@skip_msg = "Alright, skipping..."
		@win_msg = "Congratulations! You won the game!"
		@shutdown = false
	end

	#Define assessment method
	def assess(guess)
		puts "Your guess is #{guess[0]}"
		return guess.to_s.capitalize == @current_answer.to_s.capitalize
	end

	#Define method for a single testing
	def test
		#load a QA pair into current
		@qa_pairs = @qa_pairs.shuffle
		temp = @qa_pairs.pop
		@current_question = temp[0]
		@current_answer = temp[1]
		#ask question
		puts "Question: #{@current_question[0]}"
		#prompt and assess guess
		is_correct = false
		while is_correct == false do
			guess = []
			puts "Please type your answer:"
			guess << gets.chomp
			if guess[0] == "EXIT"
				@shutdown = true
				puts @shutdown_msg
				is_correct = true
			elsif guess[0] == "SKIP"
				@qa_pairs << temp
				puts @skip_msg
				is_correct = true
			elsif self.assess(guess)
				puts @correct_msg
				is_correct = true
			else
				puts @incorrect_msg
				puts "..."
			end
		end
		puts "--------------------"
		return nil
	end

	#Define method for playing a whole game through
	def start
		while @shutdown == false do
			@shutdown = true if @qa_pairs.length == 0
			puts @win_msg if @qa_pairs.length == 0
			self.test
		end
	end
end

game = Game.new("sample_data.txt")
game.start
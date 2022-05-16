require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ("a".."z").to_a
    @letters = []
    9.times { |_| @letters << alphabet.sample(1)[0].upcase }
  end

  def score
    word = params[:word]
    @word_upcase = word.split("").map {|w| w.upcase}.join()
    @letters = params[:letters]
    word_array = word.split("")
    letters_array = @letters.split(" ").map { |l| l.downcase }
    valid_array = word_array.map do |letter| 
      if letters_array.include?(letter)
        index = letters_array.find_index(letter)
        letters_array.delete_at(index)
        true
      else 
        false
      end 
    end
    @valid = valid_array.all? 
    if @valid
      response = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read)
      @found = response["found"] == true
      if @found
        @result = word.length * 13
      else
        @result = "not a valid English word"
      end
    else
      @result = "not a valid word based on the given letters: "
    end
  end
end
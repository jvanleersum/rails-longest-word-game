require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ("a".."z").to_a
    @letters = []
    9.times { |_| @letters << alphabet.sample(1)[0].upcase }
  end

  def valid?(word_array, letters_array)
    valid_array = word_array.map.all? do |letter| 
      if letters_array.include?(letter)
        index = letters_array.find_index(letter)
        letters_array.delete_at(index)
        true
      else 
        false
      end 
    end
  end

  def found?(word)
    response = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read)
    response["found"] == true
  end

  def score
    word = params[:word]
    @word_upcase = word.split("").map {|w| w.upcase}.join()
    @letters = params[:letters]
    letters_array = @letters.split(" ").map { |l| l.downcase }
    @valid = valid?(word.split(""), letters_array)
    if @valid
      @found = found?(word)
      @result = @found ? word.length * 13 : "not a valid English word" 
    else
      @result = "not a valid word based on the given letters: "
    end
  end
end
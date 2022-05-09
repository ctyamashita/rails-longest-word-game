require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    until @letters.length == 10
      @letters << ('a'..'z').to_a.sample
      @letters.uniq!
    end
  end

  def score
    attempt = params[:attempt]
    letters_array = params[:letters].chars.select { |char| char.match(/[a-z]/) }
    # checking valid word
    valid_answer = attempt.chars.all? { |letter| letters_array.include?(letter) }
    json = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    hash = JSON.parse(json)
    # ##
    @result = "Sorry but #{attempt} does not seem to be a valid English word."
    @result = "Sorry but #{attempt} can't be built out of #{letters_array.join(', ').upcase}" if hash['found']
    @result = "Congratulations! #{attempt} is a valid English word!" if hash['found'] && valid_answer
    @result = "Don't use repeated letters" if attempt.chars.uniq != attempt.chars

    @score = attempt.size * 10
    @score = 0 if hash['found'] && valid_answer && attempt.chars.uniq != attempt.chars
    # raise
  end
end

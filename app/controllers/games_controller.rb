require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @start_time = Time.now.to_f
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample.capitalize }
  end

  def score
    @time_taken = Time.now.to_f - params['start_time'].to_f
    @user_guess = params['userGuess'].upcase
    @letters = params['letters'].split(' ')
    base_url = "https://wagon-dictionary.herokuapp.com/#{@user_guess}"
    @user_score = 0
    @user_guess.split('').each do |letter|
      if @letters.include?(letter) == false
        return @message = "Sorry but #{@user_guess} can't be built out of #{@letters.join(", ")}."
      elsif @user_guess.count(letter) > @letters.count(letter)
        return @message = "Sorry but #{@user_guess} can't be built out of #{@letters.join(", ")}.
        One of your letter is replicated once or more."
      elsif JSON.parse(URI.open(base_url).read)['found'] == false
        return @message = "Sorry but #{@user_guess} is not en english word"
      end

      @message = "Congratulations! #{@user_guess} is a valid English word!"
      @user_score += (@user_guess.length * 10) / @time_taken
      @user_score.to_i
    end
  end
end

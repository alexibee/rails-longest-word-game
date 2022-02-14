require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    array = ('A'..'Z').to_a
    @letters = []
    range = Random.new
    9.times do
      @letters << array[range.rand(0..25)]
    end
    @letters
  end

  def score
    @result = if grid_check
                if parsed['found']
                  "Congratulations! #{parsed['word'].upcase} is an English word!"
                else
                  parsed['error']
                end
              else
                "Sorry but #{params[:word]} can't be built out of #{@letters} "
              end
  end

  private

  def grid_check
    @letters = params[:letters]
    let_array = @letters.downcase.split
    entered = params[:word].chars
    entered.all? { |char| let_array.include?(char) && let_array.count(char) >= entered.count(char) }
    # hash = {}
    # @letters.each { |letter| hash[letter] ? hash[letter] += 1 : hash[letter] = 1 }
    # e_hash = {}
    # entered = params[:word]
    # entered_a = entered.chars
    # entered_a.each { |char| e_hash[char] ? e_hash[char] += 1 : e_hash[char] = 1 }
    # check = e_hash.keys.reject do |key|
    #   if hash[key].nil?
    #     false
    #   else
    #     hash[key] >= e_hash[key]
    #   end
    # end
    # check.nil? ? true : false
  end

  def parsed
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    doc = URI.open(url).read
    JSON.parse(doc)
  end
end

require 'sinatra'
require 'shotgun'
require 'time_difference'

class Birthday < Sinatra::Base

  enable :sessions

  get '/' do
    erb(:index)
  end

  post '/birthday' do
    session[:name] = params[:name]
    # session[:day] = params[:day]
    # session[:month] = params[:month]
    birthday = calculate_days(params[:name], params[:month], params[:day])
    session[:greeting] = make_greeting(params[:name], birthday)

    redirect '/greeting'
  end

  get '/greeting' do
    @name = session[:name]
    @greeting = session[:greeting]

    erb(:greeting)
  end

  def calculate_days(name, month, day)
    birthday = Time.new(2019, month, day)
    now = Time.now
    difference = TimeDifference.between(birthday, now).in_days

    return 0 if difference < 1

    if difference.negative?
      -difference
    else
      difference
    end
  end

  def make_greeting(name, birthday)
    if birthday == 0
      return "Happy birthday, #{name}! It's your birthday today!"
    end
    "Hi, #{name}, it's your birthday in #{birthday} days....sorry!"
  end



  # start the server if ruby file executed directly
  run! if app_file == $0
end
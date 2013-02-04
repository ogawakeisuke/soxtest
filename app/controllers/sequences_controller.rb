class SequencesController < ApplicationController
  #before_filter :auth, :only => "index" if Rails.env.production?

  def index
  end

  def creating
    const = [ '1', '2', '3', 's' ]
    seq = []
    seq2 = []
    basedir = "#{Rails.root}/public/audio/"

    16.times do
      seq << const[rand(4)]
    end

    seq.each do |a|
      seq2 << "#{basedir}#{a}.wav\s"
    end

    str = seq2.join

    system("sox #{str} #{basedir}res1.wav")
    system("sox -m #{basedir}res1.wav #{basedir}dr.wav #{basedir}composit.wav")

    send_file("#{basedir}composit.wav")
  end

private
   def auth
    name = "test"
    pass = "test"

    authenticate_or_request_with_http_basic() do |n, p|
      n == name &&
        p == pass
    end
  end 

end

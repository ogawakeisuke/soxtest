class SequencesController < ApplicationController
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

end

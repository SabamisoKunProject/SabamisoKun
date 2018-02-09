require 'niconico'
require 'restclient'

class NiconicoHepler
  class << self
    def initialize(mail, pass)
      @mail = mail
      @pass = pass
      @n = Niconico.new([@mail, @pass])
    end

    def get_video(id)
      @n::Niconico.video(id)
    end
  end
end

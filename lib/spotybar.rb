require 'zeitwerk'
require 'base64'

class Spotybar
  class << self
    def initialize
      @loader = initialize_loader
    end

    def reload
      @loader.reload
    end

    def current_song
      dbus = Dbus.new
      dbus.to_s || ApiClient.new(dbus.track_id).to_s
    end

    private

    def root_dir
      File.expand_path("../../", Pathname.new(__FILE__).realpath)
    end

    def initialize_loader
      Zeitwerk::Loader.new.tap do |loader|
        loader.push_dir root_dir + '/lib'
        loader.enable_reloading
        loader.setup
      end
    end
  end
end

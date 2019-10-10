class Dbus
  def initialize
    base_string = `dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata`
    entries = base_string.scan(/entry\(([^)]+)\)/).flatten.map { |line| line.gsub(/[\n]/, '').gsub(/\s+/, ' ') }

    @artists  = extract_multiple(entries, /xesam:artist/, /string\s\"([^\"]+)\"/)
    @track_id = extract(entries, /mpris:trackid/, /spotify:track:([^\"]+)/)
    @song     = extract(entries, /xesam:title/, /variant string \"([^\"]+)\"/)
  end

  attr_accessor :song, :artists, :track_id

  def to_s
    return nil if artists.empty?
    return nil if song.empty?

    "#{artists}: #{song}"
  end

  private

  def extract_multiple(entries, identifier, extraction_pattern)
    entries.find { |line| line.match identifier }.split('[').last.scan(extraction_pattern).flatten.map(&:strip).join(', ')
  end

  def extract(entries, identifier, extraction_pattern)
    match = entries.find { |line| line.match identifier}.match(extraction_pattern)
    return '' unless match

    match[1]
  end
end

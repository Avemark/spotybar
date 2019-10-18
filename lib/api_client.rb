class ApiClient
  AUTH_URL = 'https://accounts.spotify.com/api/token'.freeze
  API_URL = 'https://api.spotify.com/v1/tracks/'.freeze
  CREDENTIAL_FILE = __dir__.sub('lib', 'credentials.json')

  def initialize(song_id)
    @song_id = song_id
  end

  def to_s
    "#{artist}: #{track_name}"
  end

  private

  def artist
    body['artists'].map { |artist_hash| artist_hash['name'] }.join(', ')
  end

  def track_name
    body['name']
  end

  def body
    @body ||= JSON.parse(RestClient.get("#{API_URL}#{@song_id}", { Authorization: "Bearer #{access_token}" }).body)
  end

  def access_token
    @access_token ||= fetch_access_token
  end

  def fetch_access_token
    response = RestClient.post(AUTH_URL, { grant_type: 'client_credentials' }, { Authorization: "Basic #{encoded_credentials}"})
    JSON.parse(response.body)['access_token']
  end

  def encoded_credentials
    Base64.strict_encode64("#{credentials["client_id"]}:#{credentials["client_secret"]}").chomp
  end

  def credentials
    raise StandardError, 'Missing api credentials' unless File.exist?(CREDENTIAL_FILE)

    @credentials ||= JSON.parse(File.read(CREDENTIAL_FILE))
  end
end

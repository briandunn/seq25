require 'json'
require 'pg'

# SCHEMA
# create table songs (id serial primary key not null, data json not null);

class Server
  def initialize(uri)
    @connection_params = {
      host:     uri.host,
      user:     uri.user,
      password: uri.password,
      port:     uri.port || 5432,
      dbname:   uri.path[1..-1]
    }
  end

  def create
    with_connection do |connection|
      result = connection.exec <<-SQL, [json]
        insert into songs (data) values ($1) returning id
      SQL
      JSON.dump result.first
    end
  end

  def index
    with_connection do |connection|
      result = connection.exec <<-SQL
        select id from songs
      SQL
      JSON.dump result.to_a
    end
  end

  def show(id)
    with_connection do |connection|
      result = connection.exec <<-SQL, [id]
        select data from songs where id = $1
      SQL
      result.first && result.first['data']
    end
  end


  private

  def with_connection
    connection = nil
    begin
      connection = PG.connect @connection_params
      yield connection
    ensure
      connection && connection.close
    end
  end
end

not_found = [404, JSON.dump(error: 'not found')]

map '/songs' do
  run -> env do
    server = Server.new URI ENV['DATABASE_URL']
    route = env.values_at 'REQUEST_METHOD', 'PATH_INFO'
    status, body = case route.join ' '
    when %r[^POST $]
      response = server.create env['rack.input'].read
      [201, response]
    when %r[^GET $]
      [200, server.index]
    when %r[^GET /(?<id>\d+)$]
      song = server.show $~[:id]
      (song && [200, song]) || not_found
    else
      not_found
    end
    [status, {'Content-Type' => 'application/json', 'Access-Control-Allow-Origin' => 'http://seq25.com' }, [body]]
  end
end

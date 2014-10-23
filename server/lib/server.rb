require 'json'
require 'pg'

# SCHEMA
# create table songs (
#   id serial primary key not null,
#   data json not null,
#   child_id integer references songs(id),
#   reated_at timestamptz not null default now()
# );

class Server
  def initialize(uri)
    @connection_params = {
      host:     uri.host,
      user:     uri.user,
      password: uri.password,
      port:     uri.port,
      dbname:   uri.path[1..-1]
    }.reject { |k, v| v.nil? }
  end

  def create(json)
    with_connection do |connection|
      result = connection.exec <<-SQL, [json]
        insert into songs (data) values ($1) returning id
      SQL
      parent_id = JSON.parse(json)['remoteId']

      connection.exec(<<-SQL, [result.first['id'], parent_id]) if parent_id
        update songs set child_id = $1 where id = $2
      SQL
      JSON.dump result.first
    end
  end

  def index
    with_connection do |connection|
      result = connection.exec <<-SQL
        select id from songs where child_id is null
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


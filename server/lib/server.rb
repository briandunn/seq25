require 'json'
require 'pg'
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
    json = JSON.parse json
    parent_id = json.delete 'remoteId'
    json = JSON.dump json

    with_connection do |connection|
      #FIXME: order agnostic
      id = connection.exec <<-SQL, [json]
        select id from songs where data::text = $1
      SQL

      id = id.any? && id.first['id']

      parent_id = nil unless connection.exec('select true from songs where id = $1', [parent_id]).any?
      id = connection.exec(<<-SQL, [json, parent_id]).first['id'] unless id
        insert into songs (data, parent_id) values ($1, $2) returning id
      SQL

      JSON.dump id: id
    end
  end

  def index
    with_connection do |connection|
      result = connection.exec <<-SQL
        select id from songs where id not in (
          select distinct parent_id from songs where parent_id is not null
        )
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

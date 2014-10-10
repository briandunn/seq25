require 'json'
require 'pg'

# SCHEMA
# create table songs (id serial primary key not null, data json not null);

connection = PG.connect dbname: 'seq25'

create = -> json do
  result = connection.exec <<-SQL, [json]
    insert into songs (data) values ($1) returning id
  SQL
  JSON.dump result.first
end

index = -> do
  result = connection.exec <<-SQL
    select id from songs
  SQL
  JSON.dump result.to_a
end

show = -> id do
  result = connection.exec <<-SQL, [id]
    select data from songs where id = $1
  SQL
  result.first.fetch 'data'
end

map '/songs' do
  run -> env do
    route = env.values_at 'REQUEST_METHOD', 'PATH_INFO'
    status, body = case route.join ' '
    when %r[^POST $]
      response = create.call env['rack.input'].read
      [201, response]
    when %r[^GET $]
      [200, index.call]
    when %r[^GET /(?<id>\d+)$]
      [200, show[$~[:id]]]
    else
      [404, JSON.dump(error: 'not found')]
    end
    [status, {'Content-Type' => 'application/json'}, [body]]
  end
end

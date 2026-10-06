require_relative 'lib/server'

not_found = [404, JSON.dump(error: 'not found')]

map '/songs' do
  run -> env do
    server = Server.new URI ENV['DATABASE_URL']
    route = env.values_at 'REQUEST_METHOD', 'PATH_INFO'
    code, body = case route.join ' '
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
    [code, { 'content-type' => 'application/json' }, [body]]
  end
end

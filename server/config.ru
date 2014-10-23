require 'pathname'
require Pathname(__FILE__).dirname.join 'lib/server'

not_found = [404, {}, JSON.dump(error: 'not found')]

map '/songs' do
  run -> env do
    server = Server.new URI ENV['DATABASE_URL']
    route = env.values_at 'REQUEST_METHOD', 'PATH_INFO'
    code, headers, body = case route.join ' '
    when %r[^OPTIONS $]
      [
        200,
        {
          'Access-Control-Allow-Methods' => 'POST',
          'Access-Control-Allow-Headers' => 'Content-Type'
        },
        ''
      ]
    when %r[^POST $]
      response = server.create env['rack.input'].read
      [201, {}, response]
    when %r[^GET $]
      [200, {}, server.index]
    when %r[^GET /(?<id>\d+)$]
      song = server.show $~[:id]
      (song && [200, {}, song]) || not_found
    else
      not_found
    end
    [
      code,
      headers.merge(
        'Content-Type'                => 'application/json',
        'Access-Control-Allow-Origin' => 'http://seq25.com'
      ),
      [body]
    ]
  end
end

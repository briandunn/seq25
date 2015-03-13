#!/usr/bin/env ruby

require 'minitest/spec'
require 'minitest/autorun'
require 'pathname'
require 'uri'
require Pathname(__FILE__).dirname.expand_path.join '../lib/server'

describe Server do
  attr_reader :connection, :server

  before do
    system <<-EOF
      createdb seq25test 2> /dev/null
    EOF
    @connection = PG.connect dbname: 'seq25test'
    connection.exec DATA.read
    connection.exec 'delete from songs'

    @server = Server.new URI '/seq25test'
  end

  def count
    connection.exec(<<-EOF).first['count'].to_i
      select count(*) from songs
    EOF
  end

  describe 'when no parent exists' do
    it 'stores the song' do
      id = JSON.parse(server.create(<<-JSON))['id']
        {"tempo": 5, "parts":[], "remoteId": 7}
      JSON

      id.must_match /\d+/
      count.must_equal 1
    end
  end

  describe 'when a parent exists' do
    attr_reader :parent_id
    before do
      @parent_id = connection.exec(<<-EOF).first['id']
        insert into songs (data) values ('{}') returning id
      EOF
    end

    it 'associates the parent with the new child' do
      result = server.create JSON.dump tempo: 5, parts:[], remoteId: parent_id
      child_id = JSON.parse(result)['id']

      connection.exec(<<-EOF, [child_id]).first['parent_id'].must_equal parent_id
        select parent_id from songs where id = $1
      EOF

    end

    it 'only returns the head of each list' do
      server.create JSON.dump tempo: 5, parts:[], remoteId: parent_id
      index = JSON.parse(server.index)

      index.map {|song| song['id'] }.wont_include parent_id

      index.size.must_equal 1

      count.must_equal 2
    end
  end

  describe 'when a song with the same data already exists' do
    it 'returns the id of the prior song' do
      first_id  = JSON.parse(server.create('{"tempo": 120, "parts":[]}'))['id']
      second_id = JSON.parse(server.create('{"tempo": 120, "parts":[]}'))['id']

      second_id.must_equal first_id
    end

    it 'does not add a new song' do
      JSON.parse(server.create('{"tempo": 120, "parts":[]}'))['id']
      JSON.parse(server.create('{"tempo": 120, "parts":[]}'))['id']

      count.must_equal 1
    end

    it 'does not create a child relationship' do
      server.create '{"tempo": 120, "parts":[]}'
      server.create '{"tempo": 120, "parts":[]}'
      connection.exec('select parent_id from songs').first['parent_id'].must_equal nil
    end
  end
end

__END__
create table if not exists songs (
  id serial primary key not null,
  data json not null,
  parent_id integer references songs(id),
  created_at timestamptz not null default now()
);

#!/usr/bin/env ruby

require 'minitest/spec'
require 'minitest/autorun'
require 'pathname'
require 'uri'
require Pathname(__FILE__).dirname.expand_path.join '../lib/server'

describe Server do
  attr_reader :connection

  before do
    system <<-EOF
      createdb seq25test 2> /dev/null
    EOF
    @connection = PG.connect dbname: 'seq25test'
    connection.exec DATA.read
    connection.exec 'delete from songs'
  end

  def count
    connection.exec(<<-EOF).first['count'].to_i
      select count(*) from songs
    EOF
  end

  describe '#create' do
    attr_reader :server

    before do
      @server = Server.new URI '/seq25test'
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

        connection.exec(<<-EOF, [parent_id]).first['child_id'].must_equal JSON.parse(result)['id']
          select child_id from songs where id = $1
        EOF

      end

      it 'only returns the head of each list' do
        server.create JSON.dump tempo: 5, parts:[], remoteId: parent_id
        JSON.parse(server.index).map {|song| song['id'] }.wont_include parent_id

        count.must_equal 2
      end
    end
  end
end

__END__
create table if not exists songs (
  id serial primary key not null,
  data json not null,
  child_id integer references songs(id),
  reated_at timestamptz not null default now()
);

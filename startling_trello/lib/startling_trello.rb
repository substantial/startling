require 'startling'
require 'highline/import'
require 'trello'
require_relative 'startling_trello/api'
require_relative 'startling_trello/commands/trello_start'

module StartlingTrello
  class << self
    def method_missing(method, *args, &block)
      Startling.send(method, *args, &block)
    end
  end

  def self.api
    @api ||= get_api
  end

  private

  def self.get_api
    developer_public_key = get_developer_public_key
    member_token = get_member_token(developer_public_key)

    Api.new(
      developer_public_key: developer_public_key,
      member_token: member_token
    )
  end

  def self.get_developer_public_key
    return developer_public_key unless developer_public_key.nil?

    Trello.open_public_key_url
    abort 'Trello developer API key is not configured. Get a developer public key and add it to the configuration file.'
  end

  def self.get_member_token(developer_public_key)
    Startling.cache.fetch('.trello_member_token') do
      Trello.open_authorization_url(key: developer_public_key)
      ask('Enter your member token: ')
    end
  end
end

module StartlingTrello
  class Api
    def initialize(developer_public_key:, member_token:)
      @developer_public_key = developer_public_key
      @member_token = member_token
    end
  end
end

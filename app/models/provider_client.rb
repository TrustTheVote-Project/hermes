class ProviderClient
  def self.get_status_for_voters(voters)
    new_voters = voters.where(provider_id: nil)

    new_voters.map{ |v| v.attributes.delete(:id)}

    uri = "#{ENV["PROVIDER_URL"]}/v1/voters"
    response = HTTP.post uri, { body: new_voters.to_json, headers: HTTP.basic_auth(:user => ENV["PROVIDER_TOKEN"], :pass => ENV["PROVIDER_SECRET"]) }
  end
end

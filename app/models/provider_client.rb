class ProviderClient
  uri = "#{Rails.application.credentials[:PROVIDER_URL]}"

  def self.register_voters(voters)
    alloy_params =['first_name', 'middle_name', 'last_name', 'address', 'city', 'state', 'zip']
    body = voters.map {|v| {"id" => v.provider_id}.merge(v.slice(alloy_params))}

    response = provider_update("voters", body)
    data = JSON.parse(response.body)["data"]["items"]
    data.zip(voters).each do |resp, voter|
      voter.provider_id = resp['id']
      voter.save!
    end
  end

  def self.verify_voters(voters)
    response = provider_get("voters", {})
    data = JSON.parse(response.body)["data"]["items"]
    voters.each do |voter|
      voter_data = data.detect{|v| v["id"] == voter.provider_id}
      voter.update!(registration_status: voter_data["registration_status"]) if voter_data
    end
  end

  private

  def self.provider_get(url, params)
    HTTP.basic_auth(:user => Rails.application.credentials[:PROVIDER_TOKEN], :pass => Rails.application.credentials[:PROVIDER_SECRET]).get "#{uri}/#{url}", {params: params}
  end

  def self.provider_update(url, params)
    HTTP.basic_auth(:user => Rails.application.credentials[:PROVIDER_TOKEN], :pass => Rails.application.credentials[:PROVIDER_SECRET]).post "#{uri}/#{url}", {body: params}
  end
end

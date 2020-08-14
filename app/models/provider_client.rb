class ProviderClient
  def self.register_voters(voters)
    alloy_params =['first_name', 'middle_name', 'last_name', 'address', 'city', 'state', 'zip']

    uri = "#{Rails.application.credentials[:PROVIDER_URL]}"

    body = voters.map {|v| {"id" => v.provider_id}.merge(v.slice(alloy_params))}

    response = provider_update("#{uri}/voters", body)
    data = JSON.parse(response.body)["data"]["items"]
    data.zip(voters).each do |resp, voter|
      voter.provider_id = resp['id']
      voter.save!
    end
  end

  private

  def self.provider_get(url, params)
    HTTP.basic_auth(:user => Rails.application.credentials[:PROVIDER_TOKEN], :pass => Rails.application.credentials[:PROVIDER_SECRET]).get url, {params: params}
  end

  def self.provider_update(url, params)
    HTTP.basic_auth(:user => Rails.application.credentials[:PROVIDER_TOKEN], :pass => Rails.application.credentials[:PROVIDER_SECRET]).post url, {body: params}
  end
end

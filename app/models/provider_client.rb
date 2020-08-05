class ProviderClient
  def self.get_status_for_voters(voters)
    new_voters = voters.select{|v| v.provider_id == nil}

    new_voters.map{ |v| v.attributes.delete(:id)}

    alloy_params =['first_name', 'last_name', 'address', 'city', 'state', 'zip']

    uri = "#{ENV["PROVIDER_URL"]}"

    voters.each do |voter|
      if !voter.provider_id
        response = provider_get("#{uri}/verify", voter.slice(alloy_params))
        data = JSON.parse(response.body)["data"]
        voter.provider_id = data["id"]
      else
        provider_update "#{uri}/voters/#{voter.provider_id}", voter.slice(alloy_params).merge({"id" => voter.provider_id}).to_json
        response = provider_get "#{uri}/voters/#{voter.provider_id}", {}
        data = JSON.parse(response.body)["data"]
      end

      voter.registration_status = data["registration_status"]
      voter.save!
    end
  end

  private

  def self.provider_get(url, params)
    HTTP.basic_auth(:user => ENV["PROVIDER_TOKEN"], :pass => ENV["PROVIDER_SECRET"]).get url, {params: params}
  end

  def self.provider_update(url, params)
    HTTP.basic_auth(:user => ENV["PROVIDER_TOKEN"], :pass => ENV["PROVIDER_SECRET"]).post url, {body: params}
  end
end

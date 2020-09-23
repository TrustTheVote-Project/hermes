class ProviderClient
  URI = "#{Rails.application.credentials[:PROVIDER_URL]}"

  def self.register_voters(voters)
    alloy_params =['first_name', 'middle_name', 'last_name', 'address', 'city', 'state', 'zip']
    body = voters.map {|v| {"id" => v.provider_id}.merge(v.slice(alloy_params))}

    response = provider_update("voters", body.to_json)
    data = JSON.parse(response.body)["data"]["items"]
    data.zip(voters).each do |resp, voter|
      voter.provider_id = resp['id']
      voter.save!
    end
  end

  def self.verify_voters(voters)
    data = provider_get("voters", {})
    update_voters(data, voters)
  end

  def self.get_voter_updates()
    data = provider_get("voters", {within_days: 1})
    voters = Voter.where{|v| data.map{|i| i["id"]}.includes(v.provider_id)}
    update_voters(data, voters)
  end

  def self.update_voters(data, voters)
    voters.each do |voter|
      voter_data = data.detect{|v| v["id"] == voter.provider_id}
      voter.update!(registration_status: voter_data["registration_status"]) if voter_data
    end
  end

  private

  def self.provider_get(url, params)
    page_size = 1000
    voters_recieved = 1000
    offset = 0
    items = []
    until voters_recieved < 1000
      paginated_params = params.merge({page_size: page_size, offset:offset})
      provider_auth.get "#{URI}/#{url}", {params: params}
      received = JSON.parse(response.body)["data"]["items"]
      voters_recieved = received.length
      items << received
    end
    items
  end

  def self.provider_update(url, params)
    provider_auth.post "#{URI}/#{url}", {body: params}
  end

  def self.provider_auth()
    HTTP.basic_auth(
      :user => Rails.application.credentials[:PROVIDER_TOKEN],
      :pass => Rails.application.credentials[:PROVIDER_SECRET]
      )
  end
end

class ImportVotersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # repeat 'every day at 8am' #GMT

    if Rails.application.credentials.config.dig(Rails.env.to_sym, :aws)
      aws_credentials = Aws::Credentials.new(aws_cred(:access_key_id), aws_cred(:secret_access_key))

      s3 = Aws::S3::Client.new(
        credentials: aws_credentials,
        region: aws_cred(:s3_region)
      )

      s3.list_objects_v2(bucket: "rtv-to-voteready").contents.each do |object| 
        csv = s3.get_object(bucket: "rtv-to-voteready", key: object.key).body
        Voter.import_from_csv(csv)
      end
    end
  end

  def aws_cred(name)
    Rails.application.credentials.send(Rails.env)&.dig(:aws, name)
  end
end

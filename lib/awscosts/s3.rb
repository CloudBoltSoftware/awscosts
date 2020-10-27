require 'awscosts/s3_storage'
require 'awscosts/s3_requests'
require 'awscosts/s3_data_transfer'

class AWSCosts::S3

  attr_reader :region

  REGION_MAPPING = {
       'us-east-1' => "us-std",
       'us-west-1' => "us-west-1",
       'us-west-2' => "us-west-2",
       'eu-west-1' => "eu-west-1",
       'eu-central-1' => "eu-central-1",
       'ap-southeast-1' => "ap-southeast-1",
       'ap-southeast-2' =>"ap-southeast-2",
       'ap-northeast-1' =>"ap-northeast-1",
       'sa-east-1' => "sa-east-1",
       'ap-northeast-2' => "ap-northeast-2",
       'ap-south-1' => "ap-south-1",
       'us-east-2' => "us-east-2",
       'eu-west-2' => "eu-west-2",
       'ca-central-1' => "ca-central-1",
       'af-south-1' => "af-south-1",
       'ap-east-1' => "ap-east-1",
       'eu-west-3' => "eu-west-3",
       'eu-north-1' => "eu-north-1",
       'me-south-1' => "me-south-1"
  }

  def initialize region
    @region = REGION_MAPPING[region.name]
  end

  def storage
    AWSCosts::S3Storage.fetch(@region)
  end

  def data_transfer
    AWSCosts::S3DataTransfer.fetch(@region)
  end

  def requests
    AWSCosts::S3Requests.fetch(@region)
  end
end




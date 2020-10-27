
class AWSCosts::Region

  attr_reader :name, :full_name, :price_mapping, :emr_mapping

  SUPPORTED =  {
    'us-east-1' => { :full_name => 'US (Northern Virginia)', :price_mapping => 'us-east-1', :emr_mapping => 'us-east' },
    'us-west-1' => { :full_name => 'US (Northern California)', :price_mapping => 'us-west-1', :emr_mapping => 'us-west' },
    'us-west-2' => { :full_name => 'US (Oregon)', :price_mapping => 'us-west-2', :emr_mapping => 'us-west-2' },
    'eu-west-1' => { :full_name => 'EU (Ireland)', :price_mapping => 'eu-west-1', :emr_mapping => 'eu-ireland' },
    'eu-central-1' => { :full_name => 'EU (Frankfurt)' },
    'ap-southeast-1' => { :full_name => 'Asia Pacific (Singapore)', :price_mapping => 'ap-southeast-1', :emr_mapping => 'apac-sin' },
    'ap-southeast-2' => { :full_name => 'Asia Pacific (Sydney)', :price_mapping => 'ap-southeast-2', :emr_mapping => 'apac-syd' },
    'ap-northeast-1' => { :full_name => 'Asia Pacific (Tokyo)', :price_mapping => 'ap-northeast-1', :emr_mapping => 'apac-tokyo' },
    'sa-east-1' => { :full_name => 'South America (Sao Paulo)', :price_mapping => 'sa-east-1', :emr_mapping => 'sa-east-1' },
    'ap-northeast-2' => { :full_name => 'Asia Pacific (Seoul)', :price_mapping => 'ap-northeast-2', :emr_mapping => 'ap-northeast-2' },
    'ap-south-1' => { :full_name => 'Asia Pacific (Mumbai)', :price_mapping => 'ap-south-1', :emr_mapping => 'ap-south-1' },
    'us-east-2' => { :full_name => 'US East (Ohio)', :price_mapping => 'us-east-2', :emr_mapping => 'us-east-2' },
    'ca-central-1' => { :full_name => 'Canada (Central)', :price_mapping => 'ca-central-1', :emr_mapping => 'ca-central-1' },
    'eu-west-2' => { :full_name => 'EU (London)', :price_mapping => 'eu-west-2', :emr_mapping => 'eu-west-2' },
    'af-south-1' => { :full_name => 'Africa (Cape Town)', :price_mapping => 'af-south-1', :emr_mapping => 'af-south-1' },
    'ap-east-1' => { :full_name => 'Asia Pacific (Hong Kong)', :price_mapping => 'ap-east-1', :emr_mapping => 'ap-east-1' },
    'eu-west-3' => { :full_name => 'Europe (Paris)', :price_mapping => 'eu-west-3', :emr_mapping => 'eu-west-3' },
    'eu-north-1' => { :full_name => 'Europe (Stockholm)', :price_mapping => 'eu-north-1', :emr_mapping => 'eu-north-1' },
    'me-south-1' => { :full_name => 'Middle East (Bahrain)', :price_mapping => 'me-south-1', :emr_mapping => 'me-south-1' }
  }

  def self.find name
    SUPPORTED[name] ? self.new(name) : nil
  end


  def ec2
    AWSCosts::EC2.new(self)
  end

  def emr
    AWSCosts::EMR.fetch(self.emr_mapping)
  end

  def s3
    AWSCosts::S3.new(self)
  end

  def rds
    AWSCosts::Rds.new(self)
  end

  private
  def initialize name
    @name = name
    @full_name = SUPPORTED[name][:full_name]
    @price_mapping = SUPPORTED[name][:price_mapping]
    @emr_mapping = SUPPORTED[name][:emr_mapping]
  end

end

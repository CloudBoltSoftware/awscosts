require 'awscosts/ec2_on_demand'
require 'awscosts/ec2_reserved_instances'
require 'awscosts/ec2_elb'
require 'awscosts/ec2_ebs'
require 'awscosts/ec2_ebs_optimized'
require 'awscosts/ec2_elastic_ips'

class AWSCosts::EC2

  attr_reader :region

  TYPES = { windows: 'mswin', linux: 'linux', windows_with_sql: 'mswinSQL',
            windows_with_sql_web: 'mswinSQLWeb', rhel: 'rhel', sles: 'sles' }

  REGION_MAPPING = {
    'us-east-1' => "us-east",
    'us-west-1' => "us-west",
    'us-west-2' => "us-west-2",
    'eu-west-1' => "eu-ireland",
    'eu-central-1' => "eu-central-1",
    'ap-southeast-1' => "apac-sin",
    'ap-southeast-2' =>"apac-syd",
    'ap-northeast-1' =>"apac-tokyo",
    'sa-east-1' => "sa-east-1",
    'ap-northeast-2' => "ap-northeast-2",
    'ap-south-1' => "ap-south-1",
    'eu-west-2' => "eu-west-2",
    'us-east-2' => "us-east-2",
    'ca-central-1' => "ca-central-1",
    'af-south-1' => "af-south-1",
    'ap-east-1' => "ap-east-1",
    'eu-west-3' => "eu-west-3",
    'eu-north-1' => "eu-north-1",
    'me-south-1' => "me-south-1"
  }

  EBS_RAW_MAPPING = %w(us-east-1 us-west-1 eu-west-1 ap-southeast-1 ap-southeast-2 ap-northeast-1)

  def initialize region
    @region = region
  end

  def on_demand(type)
    raise ArgumentError.new("Unknown platform: #{type}") if TYPES[type].nil?
    AWSCosts::EC2OnDemand.fetch(TYPES[type], self.region.name)
  end

  def reserved(type, utilisation = :light)
    r = self.region.name
    r = 'us-east' if r == 'us-east-1'
    raise ArgumentError.new("Unknown platform: #{type}") if TYPES[type].nil?
    AWSCosts::EC2ReservedInstances.fetch(TYPES[type], utilisation, r)
  end

  def elb
    AWSCosts::ELB.fetch(self.region.name)
  end

  def ebs
    if EBS_RAW_MAPPING.include?(self.region.name)
      AWSCosts::EBS.fetch(self.region.name)
    else
      AWSCosts::EBS.fetch(REGION_MAPPING[self.region.name])
    end
  end

  def ebs_optimized
    AWSCosts::EBSOptimized.fetch(REGION_MAPPING[self.region.name])
  end

  def elastic_ips
    AWSCosts::ElasticIPs.fetch(self.region.name)
  end
end



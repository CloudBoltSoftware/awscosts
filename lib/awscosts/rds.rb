require 'awscosts/rds_on_demand'

class AWSCosts::Rds
  attr_reader :region  

  # [{"port"=>5432, "engine"=>"postgres"}, {"port"=>3306, "engine"=>"mysql"}, {"port"=>1433, "engine"=>"sqlserver-ee"}, {"port"=>1521, "engine"=>"oracle-se1"}, {"port"=>1521, "engine"=>"oracle-se"}, {"port"=>1521, "engine"=>"oracle-ee"}]

  ENGINES = { postgres: 'postgresql', mysql: 'mysql', oracle: 'oracle', sqlserver_ex: 'sqlserver_ex', sqlserver_web: 'sqlserver_web', sqlserver_se: 'sqlserver_se', sqlserver_ee: 'sqlserver_ee'}

  REGION_MAPPING = {
   'us-east-1' => "us-east-1",
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

  OTHER_REGION_MAPPING = {
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

  def on_demand(engine, version, type, boyl=false)
    mapped_engine = ENGINES[engine.to_sym]
    raise ArgumentError.new("Unknown platform: #{engine}") if mapped_engine.nil?
    if ((engine == 'sqlserver_web' && version == "old") || (engine == 'sqlserver_se' && version == "old") || (engine == 'sqlserver_ex' && version  == "old" && boyl) || (engine == 'sqlserver_ee' && version == "old"))
      region_mapped = OTHER_REGION_MAPPING[@region]
      AWSCosts::RDSOnDemand.fetch(mapped_engine, version, type, boyl, region_mapped)
    else
      AWSCosts::RDSOnDemand.fetch(mapped_engine, version, type, boyl, @region)
    end
  end
end

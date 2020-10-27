require 'awscosts/rds'

class AWSCosts::RDSOnDemand
  MSSQL_ENGINE_MAP = %w(sqlserver_ex sqlserver_web sqlserver_se sqlserver_ee)

  TYPE_URL = {
    new: {
      mysql: {
        standard: 'pricing-standard-deployments',
        multi_az: 'pricing-multiAZ-deployments'
      },
      postgresql: {
        standard: 'pricing-standard-deployments',
        multi_az: 'pricing-multiAZ-deployments'
      },
      oracle: {
        standard: 'pricing-li-standard-deployments',
        multi_az: 'pricing-li-multiAZ-deployments'
      },
      sqlserver_ex: {
        standard: 'sqlserver-li-ex-ondemand'
      },
      sqlserver_web: {
        standard: 'sqlserver-li-web-ondemand'
      },
      sqlserver_se: {
        standard: 'sqlserver-li-se-ondemand',
        multi_az: 'sqlserver-li-se-ondemand-maz'
      },
      sqlserver_ee: {
        standard: 'sqlserver-li-ee-ondemand',
        multi_az: 'sqlserver-li-ee-ondemand-maz'
      }
    },
    old: {
      mysql: {
        standard: 'pricing-standard-deployments',
        multi_az: 'pricing-multiAZ-deployments'
      },
      postgresql: {
        standard: 'pricing-standard-deployments',
        multi_az: 'pricing-multiAZ-deployments'

      },
      oracle: {
        standard: 'pricing-li-standard-deployments',
        multi_az: 'pricing-li-multiAZ-deployments'
      },
      sqlserver_ex: {
        standard: 'sqlserver-li-ex-ondemand'
      },
      sqlserver_web: {
        standard: 'sqlserver-li-web-ondemand'
      },
      sqlserver_se: {
        standard: 'sqlserver-li-se-ondemand',
        multi_az: 'sqlserver-li-se-ondemand-maz'
      }
    }
  }

  BYOL_TYPE_URL = {
    new: {
      oracle: {
        standard: 'pricing-byol-standard-deployments',
        multi_az: 'pricing-byol-multiAZ-deployments'
      },
      sqlserver_ex: {
        standard: 'sqlserver-byol-ondemand',
        multi_az: 'sqlserver-byol-ondemand-maz'
      },
      sqlserver_web: {
        standard: 'sqlserver-byol-ondemand',
        multi_az: 'sqlserver-byol-ondemand-maz'
      },
      sqlserver_se: {
        standard: 'sqlserver-byol-ondemand',
        multi_az: 'sqlserver-byol-ondemand-maz'
      },
      sqlserver_ee: {
        standard: 'sqlserver-byol-ondemand',
        multi_az: 'sqlserver-byol-ondemand-maz'
      }
    },
    old: {
      oracle: {
        standard: 'pricing-byol-standard-deployments',
        multi_az: 'pricing-byol-multiAZ-deployments'
      },
      sqlserver_ex: {
        standard: 'sqlserver-byol-ondemand',
        multi_az: 'sqlserver-byol-ondemand-maz'
      },
      sqlserver_web: {
        standard: 'sqlserver-byol-ondemand',
        multi_az: 'sqlserver-byol-ondemand-maz'
      },
      sqlserver_ee: {
        standard: 'sqlserver-byol-ondemand',
        multi_az: 'sqlserver-byol-ondemand-maz'
      },
      sqlserver_se: {
        standard: 'sqlserver-byol-ondemand',
        multi_az: 'sqlserver-byol-ondemand-maz'
      }
    }
  }

  def initialize data
    @data = data
  end

  def data
    @data
  end

  def self.fetch engine, version, type, byol, region
  #engine - mysql/postgres/oracle/sqlserver, #version - new/old, type - standard/multi_az, byol - true/false

    mapped_engine = MSSQL_ENGINE_MAP.include?(engine) ? 'sqlserver' : engine
    result = {}
    if (version == "new" && !byol)
      uri_type = "/pricing/1/rds/#{mapped_engine}/#{TYPE_URL[version.to_sym][engine.to_sym][type.to_sym]}.min.js"
    elsif (version == "old" && !byol)
      uri_type = "/pricing/1/rds/#{mapped_engine}/previous-generation/#{TYPE_URL[version.to_sym][engine.to_sym][type.to_sym]}.min.js"
    elsif (version == "new" && byol)
      uri_type = "/pricing/1/rds/#{mapped_engine}/#{BYOL_TYPE_URL[version.to_sym][engine.to_sym][type.to_sym]}.min.js"
    elsif (version == "old" && byol)
      uri_type = "/pricing/1/rds/#{mapped_engine}/previous-generation/#{BYOL_TYPE_URL[version.to_sym][engine.to_sym][type.to_sym]}.min.js"
    else
      raise "Engine #{mapped_engine} or version #{version} or type #{type} not found"
    end

    AWSCosts::Cache.get_jsonp(uri_type) do |data|
      data['config']['regions'].each do |r|
        result[r['region']] ||= {}
        r['types'].each do |type_t|
          type_t['tiers'].each do |tier|
            price_name_map = { tier['name'] => tier['prices']['USD'].to_f }
            result[r['region']].merge!(price_name_map)
          end
        end
      end
    end
    self.new(result[region])
  end
end

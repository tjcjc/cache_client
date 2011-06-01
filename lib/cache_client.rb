module CacheClient

  def self.included(base)
    base.extend         ClassMethods
    base.class_eval do
      
    end
    base.send :include, InstanceMethods
  end # self.included

  module ClassMethods
    attr_reader :servers
    def cache_client(name, cache_server, options ={})
      @servers ||= {}
      @servers[name.to_sym] = cache_server
      self.instance_eval <<-END
        def get_#{name}(keys)
          cached_keys = keys.map{|key| servers_field_key(key, "#{name}")}
          if servers[:#{name}].class.to_s.match("Redis")
            servers[:#{name}].mget(cached_keys.join(","))
          else
            servers[:#{name}].mulit_get(cached_keys)
          end
        end

        def del_#{name}(keys)
          cached_keys = keys.map{|key| servers_field_key(key, "#{name}")}
          if servers[:#{name}].class.to_s.match("Redis")
            cached_keys.each do |k|
              servers[:#{name}].del(k)
            end
          else
            cached_keys.each do |k|
              servers[:#{name}].set(k, nil)
            end
          end
        end
      END

      self.class_eval <<-END
        def #{name}=(value)
          self.class.servers[:#{name}].set(servers_field_key("#{name}"), value)
        end
        def #{name}
          self.class.servers[:#{name}].get(servers_field_key("#{name}"))
        end
      END
      #if options[:default].nil?
        #self.class_eval <<-END
          #def #{name}
            #@cached_value ||= self.class.servers[:#{name}].get(servers_field_key("#{name}"))
          #end
        #END
      #else
        #self.class_eval <<-END
          #def #{name}
            #cached_value = self.class.servers[:#{name}].get(servers_field_key("#{name}"))
            #if cached_value.nil?
              ##{name}= #{options[:default]}
              #return #{options[:defualt]}
          #else
              #cached_value
            #end
          #end
        #END
      #end
    end

    def servers_field_key(key,name)
      "#{servers_prefix}:#{key}:#{name}"
    end
    def servers_prefix=(servers_prefix) @servers_prefix = servers_prefix end
    def servers_prefix(klass = self) #:nodoc:
      @servers_prefix ||= klass.name.to_s.
        sub(%r{(.*::)}, '').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        downcase
    end
  end # ClassMethods

  module InstanceMethods
    def servers_field_key(name)
      "#{self.class.servers_prefix}:#{id}:#{name}"
    end
  end # InstanceMethods

end

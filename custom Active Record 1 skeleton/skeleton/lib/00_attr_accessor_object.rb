class AttrAccessorObject
  def self.my_attr_accessor(*names)
    # ...

    names.each do |nm|

      define_method(nm) do
       
               instance_variable_get("@#{nm}")
          
      end
            
                define_method("#{nm}=") do |v|
                      
                    instance_variable_set("@#{nm}",v)

                end

    end

    end
  
  
  
end

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
            SELECT
          {source_table}.*
        FROM
          {through_table}
        JOIN
          {source_table}
        ON
          {through_table}.{source_fk} = {source_table}.{source_pk}
        WHERE
          {through_table}.{through_pk} = ?
      SQL
    end

    end
  
  
  
end

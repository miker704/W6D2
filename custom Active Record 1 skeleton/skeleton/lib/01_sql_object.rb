require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # ...
    return @columns if @columns # return column is it yields some truthy value
    # establish data base connections
    colums = DBConnection.execute2(<<-SQL).first
    select *
    from 
      #{self.table_name}
    limit 0
    SQL
    colums.map!(&:to_sym)
    @columns=colums
  end

  def self.finalize!
    self.columns.each do |name|
      define_method(name) do
        self.attributes[name]
      end

  end

  def self.table_name=(table_name)
    @table_name = table_name
    # ...
  end

  def self.table_name
    # ...
    @table_name || self.name.underscore.pluralize
  end

  def self.all
    # ...
    search_result = DBConnection.execute(<<-SQL)
    SELECT #{table_name}.*
    FROM #{tabel_name}
    SQL
    parse_all(search_result)
  end

  def self.parse_all(results)
    # ...
    results.map |num| self.new(num)
  end

  def self.find(id) #find by id 
    search_result = DBConnection.execute(<<-SQL)
    SELECT #{table_name}.*
    FROM #{tabel_name}
    SQL

    # ...
  end

  def initialize(params = {})
    # ...
    params.each do |attr_name, value|
      # make sure to convert keys to symbols
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end

    
  end

  def attributes
    # ... assign attribs as null or some hash
    @attributes ||={}


  end

  def attribute_values
    # ...

    return self.class.columns.map do |attr|
       self.send(atrr)
    end
      
  
  end

  def insert
    # ...
    columns = self.class.columns.drop(1)
    col_names = columns.map(&:to_s).join(", ")
    question_marks = (["?"] * columns.count).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    # ...
    set_line = self.class.columns
    .map { |attr| "#{attr} = ?" }.join(", ")

  DBConnection.execute(<<-SQL, *attribute_values, id)
    UPDATE
      #{self.class.table_name}
    set {set_line}
    where #{self.class.table_name}.id = ?
  SQL


  end

  def save
    # ...

    return  id.nil? ? insert : update

  end
end

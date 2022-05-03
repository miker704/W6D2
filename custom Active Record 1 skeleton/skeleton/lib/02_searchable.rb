require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    # ...
    w_line = params.keys.map { |key| "#{key} = ?" }.join(" AND ")
    res = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{table_name}
      where
        #{w_line}
    SQL

    parse_all(results)
    
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end

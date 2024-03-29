require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      results = DBConnection.execute(<<-SQL, )
        SELECT
          #{source_options.model_class.table_name}.*
        FROM
          #{through_options.table_name}
        JOIN
          #{source_options.model_class.table_name}
          ON #{through_options.table_name}.#{source_options.foreign_key} = #{source_options.model_class.table_name}.#{source_options.primary_key}
        WHERE
          #{through_options.table_name}.id = #{send(through_options.foreign_key)}
      SQL
      results.map { |row| source_options.model_class.new(row)}.first
    end
  end
end

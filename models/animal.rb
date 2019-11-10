require_relative( '../db/sql_runner.rb' )

class Animal

  attr_reader :id, :name, :d_o_b, :type, :notes, :vet_id, :owner_id
  attr_reader :id, :name, :d_o_b, :type, :notes, :vet_id, :owner_id

  def initialize (options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @d_o_b = options['d_o_b']
    @type = options['type']
    @notes = options['notes']
    @vet_id = options['vet_id'].to_i
    @owner_id = options['owner_id'].to_i
  end

  # 1
  # .to_i - does that mean when psql talks to PG, it's set up so that serial ids come back as integers?
  # Inheriting PG - I presume it inherits from sql_runner?

  def save()
    sql = "INSERT INTO animals
    (
      name,
      d_o_b,
      type,
      notes,
      vet_id,
      owner_id
    )
    VALUES
    (
      $1, $2, $3, $4, $5, $6
    )
    RETURNING id"
    values = [@name, @d_o_b, @type, @notes, @vet_id, @owner_id]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def delete()
    sql = "DELETE FROM animals
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
  sql = "UPDATE animals
  SET
  (
    name,
    d_o_b,
    type,
    notes,
    vet_id,
    owner_id
  ) =
  (
    $1, $2, $3, $4, $5, $6
  )
  WHERE id = $7"
  values = [@name, @d_o_b, @type, @notes, @vet_id, @owner_id, @id]
  SqlRunner.run(sql, values)
end

  def self.delete_all()
    sql = "DELETE FROM animals"
    SqlRunner.run (sql)
  end

  def self.all()
    sql = "SELECT * FROM animals"
    results = SqlRunner.run( sql )
    return results.map { |hash| Animal.new( hash) }
  end

end
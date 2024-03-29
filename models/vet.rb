require_relative( '../db/sql_runner.rb' )

class Vet

  attr_reader :id, :name
  attr_writer :id, :name

  def initialize (options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save()
    sql = "INSERT INTO vets
    (
      name
    )
    VALUES
    (
      $1
    )
    RETURNING id"
    values = [@name]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def delete()
    sql = "DELETE FROM vets
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE vets
    SET name = $1
    WHERE id = $2"
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end

  def owners
    sql = "SELECT owners.* FROM owners
    INNER JOIN animals
    ON owners.id = animals.owner_id
    WHERE animals.vet_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map { |owner| Owner.new(owner)}
  end
  #Give all the owners of all the animals
  # this one vet is operating on.

  def animals
    sql = "SELECT animals.* FROM animals
    WHERE animals.vet_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map { |animal| Animal.new(animal)}
  end


  def self.delete_all()
    sql = "DELETE FROM vets"
    SqlRunner.run (sql)
  end

  def self.all()
    sql = "SELECT * FROM vets"
    results = SqlRunner.run( sql )
    return results.map { |hash| Vet.new( hash) }
  end

  def self.find( id )
    sql = "SELECT * FROM vets
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values )
    return Vet.new( results.first)
  end

end

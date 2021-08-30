require 'sqlite3'
require 'singleton'

class PlayDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('plays.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Play
  attr_accessor :id, :title, :year, :playwright_id

  def self.all
    data = PlayDBConnection.instance.execute("SELECT * FROM plays")
    data.map { |datum| Play.new(datum) }
  end

  # Starting Task------------------------------------------------------------------------------------------------

  def find_by_title(title)
    #create instance
    play = PlayDBConnection.instance.execute(<<-SQL, @title)
    SELECT 
      *
    FROM 
      plays
    WHERE 
      title = ?
    SQL

    return nil unless play.length > 0
  end

  def find_by_playwright(name)
    #create instance
    playwright = playwright.find_by_name(name)
    raise "#{name} not found in DB" unless playwright

    plays = PlayDBConnection.instance.execute(<<-SQL, playwright.id)
    
    SELECT 
      *
    FROM 
      plays
    WHERE
      playwright_id = ?
    SQL

    plays.map { |play| Play.new(play) }
  end

#Ending Task-----------------------------------------------------------------------------------------------------
  

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @year = options['year']
    @playwright_id = options['playwright_id']
  end

  def create
    raise "#{self} already in database" if @id
    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id)
      INSERT INTO
        plays (title, year, playwright_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id
    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id, @id)
      UPDATE
        plays
      SET
        title = ?, year = ?, playwright_id = ?
      WHERE
        id = ?
    SQL
  end
    
 

# Starting Task--------------------------------------------------------------------------------------------------

class Playwright
  attr_accessor :id, :name, :birth_year

  def self.all
    
    data = PlayDBConnection.instance.execute("SELECT * FROM playwright")
    data.map { |datum| Playwright.new(datum) }
  end

  def find_by_name(name)
    person = PlayDBConnection.instance.execute(<<-SQL, name)

      SELECT
        *
      FROM 
        playwrights
      WHERE 
        name = ?
    SQL

    return nil unless person.name > 0
    
    Playwright.new(person.first)
  end

  def initialize(options)
    @id = options["id"]
    @name = options("name")
    @birth_year = options("birth_year")
  end

  def create
    raise "#{self} already in database" if @id
    PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year)

      INSERT INTO
        playwrights (name, birth_year)
      VALUES 
        (?,?)
    SQL

    @id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "{self} not in database" unless @id
    PlayDBconnection.instance.execute(<<-SQL, @name, @birth_year, @id)
      UPDATE
        playwrights
      SET 
        name = ?, birth_year = ?
      WHERE 
        id = ?
    SQL
  end

  def get_plays
    raise "{self} not found in database" unless @id

    plays = PlayDBConnection.instance.execute(<<-SQL, @id)
    SELECT
      *
    FROM
      plays
    WHERE
      playwright_id = ?
    SQL
    plays.map { |play| Play.new(play) }
  end
end

#Ending Task------------------------------------------------------------------------------------------------------


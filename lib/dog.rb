class Dog
    attr_accessor :name, :breed
    attr_reader :id
   
        
    def initialize(id: nil, name:, breed:)
        @id = id
        @name = name
        @breed = breed
    end 

    def self.create_table
        sql = <<-SQL 
        CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT, 
            breed TEXT
            ); 
            SQL
        DB[:conn].execute(sql)
    end 

    def self.drop_table
        sql = "DROP TABLE dogs"
        DB[:conn].execute(sql)
    end 

    def save
        sql = "INSERT INTO dogs (name, breed) VALUES (?,?)"
        DB[:conn].execute(sql, self.name, self.breed)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
        Dog.new(name: name , breed: breed, id: id)
    end 

    def self.create(name:, breed:)
        dog = Dog.new(name: name, breed: breed)
        dog.save
        dog 
    end 


    def self.new_from_db(row)
        new_dog = self.new(id: row[0], name: row[1],breed: row[2])
        new_dog
    end 

    def self.find_by_id(id)
        sql = "SELECT * FROM dogs WHERE id = ?;"
        row = DB[:conn].execute(sql, id).flatten
        Dog.new(id: row[0], name: row[1], breed: row[2])
    end 

    def self.find_or_create_by(name:, breed:)
        sql = <<-SQL
        SELECT * FROM dogs 
        WHERE name = ?
        AND breed = ?;
        SQL
        row = DB[:conn].execute(sql, name, breed).flatten
        if row[0]
            Dog.new(id: row[0], name: row[1], breed: row[2])
        else 
            self.create(name:name, breed:breed)
        end 
    end 

    def self.find_by_name(name)
        sql = "SELECT * FROM dogs WHERE name = ?"
        row = DB[:conn].execute(sql, name).flatten
        Dog.new(id: row[0], name: row[1], breed: row[2])
    end 

    def update 
        sql = <<-SQL
        UPDATE dogs 
        SET name = ?, breed = ? WHERE id = ?;
        SQL
        DB[:conn].execute(sql, self.name, self.breed, self.id)
    end 
    
end 

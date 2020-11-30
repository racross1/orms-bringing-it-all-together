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

# class Student

#   attr_accessor :name, :grade
#   attr_reader :id
  
#     def initialize(id=nil, name, grade)
#       @id = id
#       @name = name
#       @grade = grade
#     end
  
#   def self.create_table 
#     sql = <<-SQL
#     CREATE TABLE IF NOT EXISTS students (
#       id INTEGER PRIMARY KEY,
#       name TEXT,
#       grade INTEGER
#     )
#     SQL
#     DB[:conn].execute(sql)
#   end 

#   def self.drop_table
#     sql = <<-SQL
#     DROP TABLE students
#     SQL
#     DB[:conn].execute(sql)
#   end 

#   def save
#     if self.id
#       self.update
#     else
#       sql = <<-SQL
#         INSERT INTO students (name, grade)
#         VALUES (?, ?)
#       SQL
#      DB[:conn].execute(sql, self.name, self.grade)
#      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
#       end
#     end

#   def update
#     sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"      
#     DB[:conn].execute(sql, self.name, self.grade, self.id)
#   end
  
#   def self.create(name, grade)
#     student = Student.new(name, grade)
#     student.save
#     student 
#   end 

#   def self.new_from_db(row)
#     new_student = self.new(row[0], row[1], row[2])
#     new_student
#   end 

#   def self.find_by_name(name)
#     sql = <<-SQL
#     SELECT * 
#     FROM students
#     WHERE name = ?
#     LIMIT 1
#     SQL

#     DB[:conn].execute(sql, name).map do |row|
#       self.new_from_db(row)
#     end.first
#   end 

# end

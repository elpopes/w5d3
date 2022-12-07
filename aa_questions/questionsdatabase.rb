require 'sqlite3'
require 'singleton'

class QuestionsDataBase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    
    attr_accessor :id, :fname, :lname

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def create
        raise "#{self} already in database" if @id
        QuestionsDataBase.instance.execute(<<-SQL, @fname, @lastname)
            INSERT INTO
                users (fname, lname)
            VALUES
                (?, ?)
        SQL
        id = QuestionsDataBase.instance.last_insert_row_id
    end

end

class Question

end

class QuestionFollow

end

class Reply

end

class QuestionLike
    
end